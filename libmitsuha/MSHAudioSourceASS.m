#import <arpa/inet.h>
#import <sys/time.h>
#import "public/MSHAudioSourceASS.h"

const int one = 1;

@implementation MSHAudioSourceASS

-(id)init {
    self = [super init];

    empty = (float *)malloc(sizeof(float) * 1024);
    for (int i = 0; i < 1024; i++) {
        empty[i] = 0.0f;
    }

    self.isRunning = false;

    return self;
}

-(void)start {
    NSLog(@"[libmitsuha] -(void)start called");
    forceDisconnect = false;
    if (self.isRunning) return;
    self.isRunning = true;
    connfd = -1;
    [self.delegate updateBuffer:empty withLength:1024];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int retries = 0;

        while (!forceDisconnect) {
            int r = -1;
            int rlen = 0;
            float *data = NULL;
            UInt32 len = sizeof(float);
            
            NSLog(@"[libmitsuha] Connecting to mediaserverd.");
            retries++;
            connfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

            if (connfd == -1) {
                usleep(1000 * 1000);
                NSLog(@"[libmitsuha] Connection failed.");
                continue;
            }

            struct timeval tv;
            tv.tv_sec = 0;
            tv.tv_usec = 50000;
            setsockopt(connfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&tv, sizeof tv);
            setsockopt(connfd, SOL_SOCKET, SO_SNDTIMEO, (const char*)&tv, sizeof tv);
            setsockopt(connfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));

            struct sockaddr_in remote;
            remote.sin_family = PF_INET;
            remote.sin_port = htons(ASSPort);
            inet_aton("127.0.0.1", &remote.sin_addr);
            int cretries = 0;
            
            while (r != 0 && cretries < 10) {
                cretries++;
                r = connect(connfd, (struct sockaddr *)&remote, sizeof(remote));
                usleep(200 * 1000);
            }

            if (r != 0) {
                NSLog(@"[libmitsuha] Connection failed.");
                retries++;
                usleep(1000 * 1000);
                continue;
            }

            if (retries > 10) {
                forceDisconnect = true;
                NSLog(@"[libmitsuha] Too many retries. Aborting.");
                break;
            }

            retries = 0;
            NSLog(@"[libmitsuha] Connected.");

            fd_set readset;
            int result = -1;
            FD_ZERO(&readset);
            FD_SET(connfd, &readset);

            while(!forceDisconnect) {
                if (connfd < 0) break;
                result = select(connfd+1, &readset, NULL, NULL, &tv);

                if (result < 0) {
                    close(connfd);
                    break;
                }

                rlen = recv(connfd, &len, sizeof(UInt32), 0);

                if (connfd < 0) break;

                if (rlen < sizeof(UInt32)) {
                    close(connfd);
                    connfd = -1;
                    break;
                }

                if (len > 8192 || len < 0) {
                    close(connfd);
                    break;
                }

                if (len > sizeof(float)) {
                    free(data);
                    data = (float *)malloc(len);
                    rlen = recv(connfd, data, len, 0);

                    if (connfd < 0) break;

                    if (rlen > 0) {
                        retries = 0;
                        if (self.delegate) {
                            [self.delegate updateBuffer:data withLength:rlen/sizeof(float)];
                        } else {
                            close(connfd);
                            connfd = -1;
                        }
                    } else {
                        if (rlen == 0) close(connfd);
                        connfd = -1;
                        len = sizeof(float);
                        data = empty;
                    }
                }

                usleep(16 * 1000);
                rlen = send(connfd, &one, sizeof(int), 0);
                if (rlen <= 0) {
                    close(connfd);
                    connfd = -1;
                    break;
                }
            }

            if (forceDisconnect) {
                NSLog(@"[libmitsuha] Forcefully disconnected.");
                close(connfd);
                connfd = -1;
                break;
            }

            NSLog(@"[libmitsuha] Lost connection.");
            usleep(1000 * 1000);
        }
        
        self.isRunning = false;
        
        NSLog(@"[libmitsuha] Finally disconnected.");
    });
}

-(void)stop {
    NSLog(@"[libmitsuha] -(void)stop called");
    forceDisconnect = true;
}

@end