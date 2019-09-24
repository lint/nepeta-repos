#import <AudioToolbox/AudioToolbox.h>
#import <arpa/inet.h>
#import <sys/time.h>
#define ASSPort 43333

AudioBufferList *p_bufferlist = NULL;
float *empty = NULL;

%hookf(OSStatus, AudioUnitRender, AudioUnit unit, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inOutputBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
    AudioComponentDescription unitDescription = {0};
    AudioComponentGetDescription(AudioComponentInstanceGetComponent(unit), &unitDescription);
    
    if (unitDescription.componentSubType == 'mcmx') {
        if (inNumberFrames > 0) {
            p_bufferlist = ioData;
        } else {
            p_bufferlist = NULL;
        }
    }

    return %orig;
}

void handle_connection(int connfd)
{
    NSLog(@"[ASS] [%d] Connection opened.", connfd);
    struct timeval tv;
    tv.tv_sec = 5;
    tv.tv_usec = 0;

    UInt32 len = sizeof(float);
    int rlen = 0;
    float *data = NULL;
    char buffer[128];

    fd_set readset;
    int result = -1;
    FD_ZERO(&readset);
    FD_SET(connfd, &readset);

    while(connfd != -1) {
        result = select(connfd+1, &readset, NULL, NULL, &tv);

        if (result < 0) {
            close(connfd);
            break;
        }
        
        // Wait for anything to come from the client.
        rlen = recv(connfd, buffer, sizeof(buffer), 0);
        if (rlen <= 0) {
            if (rlen == 0) {
                close(connfd);
            }
            break;
        }

        // Send a dump of current audio buffer to the client.
        data = NULL;

        if (p_bufferlist != NULL) {
            len = (*p_bufferlist).mBuffers[0].mDataByteSize;
            data = (float *)(*p_bufferlist).mBuffers[0].mData;
        } else {
            len = sizeof(float);
            data = empty;
        }

        rlen = send(connfd, &len, sizeof(UInt32), 0);
        if (rlen > 0) {
            rlen = send(connfd, data, len, 0);
        }
        
        if (rlen <= 0) {
            if (rlen == 0) {
                close(connfd);
            }
            break;
        }
    }

    NSLog(@"[ASS] [%d] Connection closed.", connfd);
}

void server()
{
    NSLog(@"[ASS] Server created...");
    struct sockaddr_in local;
    local.sin_family = AF_INET;
    local.sin_addr.s_addr = htonl(INADDR_LOOPBACK); //INADDR_ANY if you want to expose audio output
    local.sin_port = htons(ASSPort);
    int listenfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

    int r = -1;
    while(r != 0) {
        r = bind(listenfd, (struct sockaddr*)&local, sizeof(local));
        usleep(200 * 1000);
    }
    NSLog(@"[ASS] Bound");

    int one = 1;
    setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
    setsockopt(listenfd, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
    setsockopt(listenfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));

    r = -1;
    while(r != 0) {
        r = listen(listenfd, 20);
        usleep(200 * 1000);
    }
    NSLog(@"[ASS] Listening");

    while(true) {
        int connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);
        if (connfd > 0) {
            struct timeval tv;
            tv.tv_sec = 5;
            tv.tv_usec = 0;
            setsockopt(connfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&tv, sizeof tv);
            setsockopt(connfd, SOL_SOCKET, SO_SNDTIMEO, (const char*)&tv, sizeof tv);
            setsockopt(connfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                handle_connection(connfd);
            });
        }
    }
}

%ctor {
    empty = (float *)malloc(sizeof(float));
    empty[0] = 0.0f;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        server();
    });
    %init;
}