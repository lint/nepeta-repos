#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "../BCCommon.h"
#import "Tweak.h"
#import <UIKit/UIButton.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SpringBoard.h>

static BOOL bcActive = false;
static BOOL bcDisableInCalls = true;
static BOOL bcMSDForceDisable = false;
static BOOL isMSD = false;
static BOOL isSpringboard = false;
static NSMutableArray *bcCaptureSessions = [[NSMutableArray alloc] initWithCapacity:250];
static NSMutableArray *bcLocationManagers = [[NSMutableArray alloc] initWithCapacity:250];

%group BCMSD

%hookf(OSStatus, AudioUnitProcess, AudioUnit unit, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inNumberFrames, AudioBufferList *ioData) {
    OSStatus orig = %orig;

    if (bcActive && !bcMSDForceDisable) {
        AudioComponentDescription unitDescription = {0};
        AudioComponentGetDescription(AudioComponentInstanceGetComponent(unit), &unitDescription);

        // Replaces microphone input with silence.
        if (unitDescription.componentSubType == 'agcc' || unitDescription.componentSubType == 'agc2') {
            if (inNumberFrames > 0) {
                inNumberFrames = 1;
                for (int i = 0; i < (*ioData).mNumberBuffers; i++) {
                    float *buffer = (float *)(*ioData).mBuffers[i].mData;
                    for (int j = 0; j < (*ioData).mBuffers[i].mDataByteSize/sizeof(float); j++) {
                        buffer[j] = 0.0;
                    }
                }
            }
        }
    }

    return orig;
}

%end

%group BCEverythingElse

@interface CLLocationManager(BegoneCIA)
@property (nonatomic, retain) id bcDelegate;

-(void)bcUpdate;

@end


@interface AVCaptureSession(BegoneCIA)
@property (nonatomic, retain) NSMutableArray *bcInputs;

-(void)bcUpdate;

@end

%hook CLLocationManager

%property (nonatomic, retain) id bcDelegate;

-(id)delegate {
    if (bcActive) {
        return NULL;
    } else {
        return %orig;
    }
}

-(void)setDelegate:(id)arg1 {
    // If we remove the delegate then that given app won't receive location updates.
    // TODO: [maybe] send fake updates to the delegate, proper GPS spoof in a future update?

    if (arg1) self.bcDelegate = arg1;
    
    if (![bcLocationManagers containsObject:self]) {
        [bcLocationManagers addObject:self];
    }

    if (bcActive) {
        arg1 = NULL;
    }

    %orig;
}

-(CLLocation *)location {
    if (bcActive) {
        return [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    } else {
        return %orig;
    }
}

%new
-(void)bcUpdate {
    if (!bcActive) {
        self.delegate = self.bcDelegate;
    } else {
        self.delegate = NULL;
    }
}

%end

// This kills the camera app :c
/*%hookf(CVImageBufferRef, CMSampleBufferGetImageBuffer, CMSampleBufferRef sbuf) {
    return NULL;
}*/

%hook AVCaptureSession

%property (nonatomic, retain) NSMutableArray *bcInputs;

-(void)addInput:(id)arg1 {
    // TODO: find a better way

    if (!self.bcInputs) {
        self.bcInputs = [[NSMutableArray alloc] initWithCapacity:250];
    }
    
    if (![bcCaptureSessions containsObject:self]) {
        [bcCaptureSessions addObject:self];
    }
    
    if ([arg1 isKindOfClass:[AVCaptureDeviceInput class]]) {
        AVCaptureDeviceInput *input = (AVCaptureDeviceInput *)arg1;
        AVCaptureDevice *device = [input device];

        // We only want to block camera streams.
        // Microphone streams are properly handled by the mediaserverd hook.
        // I should hook the .mediacapture instead, but for now this will work.

        // Welp, it doesn't do what I wanted it to do, sadly.
        if ([device hasMediaType:AVMediaTypeVideo] || [device hasMediaType:AVMediaTypeMuxed]) {
            if (![self.bcInputs containsObject:arg1]) [self.bcInputs addObject:arg1];

            if (!bcActive) {
                %orig;
            }
            return;
        }
    }

    %orig;
}

-(void)removeInput:(id)arg1 {
    if (!bcActive) [self.bcInputs removeObject:arg1];

    %orig;
}

%new
-(void)bcUpdate {
    if (!self.bcInputs) return;
    if (!bcActive) {
        for (id obj in self.bcInputs) {
            if (obj) [self addInput:obj];
        }
    } else {
        for (id obj in self.bcInputs) {
            if (obj) [self removeInput:obj];
        }
    }
}

%end

%end

NSMutableArray* BCGetDisabledApps() {
    NSMutableDictionary *appList = [[NSMutableDictionary alloc] initWithContentsOfFile:BCApplistFile];
    NSMutableArray *disabledApps = [[NSMutableArray alloc] init];
    for (NSString *key in appList) {
        if ([[appList objectForKey:key] boolValue]) {
            [disabledApps addObject:key];
        }
    }

    return disabledApps;
}

void BCSBCheckIsAppDisabled() {
    NSMutableArray *disabledApps = BCGetDisabledApps();
    SBApplication *frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
    if (frontApp) {
        NSString *currentAppDisplayID = [frontApp bundleIdentifier];
    
        if ([disabledApps containsObject:currentAppDisplayID]) {
            BCNotifyDisableMSD();
        } else {
            BCNotifyEnableMSD();
        }
    }
    [disabledApps release];
}

void HBCBPreferencesChanged() {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:BCPreferencesIdentifier];
	bcActive = [([preferences objectForKey:BCEnabled] ?: @(false)) boolValue];
	bcDisableInCalls = [([preferences objectForKey:@"DisableInCalls"] ?: @(true)) boolValue];

    if (isSpringboard) {
        BCSBCheckIsAppDisabled();
    }

    if (isMSD) {
        return;
    }

    NSMutableArray *disabledApps = BCGetDisabledApps();
    if ([disabledApps containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        bcActive = false;
    }
    [disabledApps release];

    for (id obj in bcLocationManagers) {
        if (obj) {
            CLLocationManager *manager = (CLLocationManager *)obj;
            [manager bcUpdate];
        }
    }

    for (id obj in bcCaptureSessions) {
        if (obj) {
            AVCaptureSession *session = (AVCaptureSession *)obj;
            [session bcUpdate];
        }
    }
}

void BCMSDDisable() {
    bcMSDForceDisable = true;
}

void BCMSDEnable() {
    bcMSDForceDisable = false;
}

void BCAppChanged() {
    BCNotifyAppChange();
}

%group BCSpringboard

%hook SBTelephonyManager

-(void)callEventHandler:(NSNotification*)arg1 {
    if (arg1 && arg1.object) {
        TUProxyCall *call = arg1.object;
        /*
            call.status:
            1 - call established
            3 - outgoing connecting
            4 - incoming ringing
            5 - disconnecting
            6 - disconnected
            // The above is stolen from: https://github.com/laoyur/CallKiller-iOS/blob/master/callkiller/callkiller.xm
        */

        if (call.status == 1 && bcDisableInCalls) {
            BCNotifyDisableMSD();
        } else if (call.status == 5 || call.status == 6) {
            BCSBCheckIsAppDisabled();
        }
    }
    %orig;
}

%end

%end

%ctor {
    NSArray *blacklist = @[
        @"backboardd",
        @"duetexpertd",
        @"lsd",
        @"nsurlsessiond",
        @"assertiond",
        @"ScreenshotServicesService",
        @"com.apple.datamigrator",
        @"CircleJoinRequested",
        @"nanotimekitcompaniond",
        @"ReportCrash",
        @"ptpd"
    ];

    NSString *processName = [NSProcessInfo processInfo].processName;
    for (NSString *process in blacklist) {
        if ([process isEqualToString:processName]) {
            NSLog(@"[BegoneCIA] ignored process: %@", processName);
            return;
        }
    }

    isMSD = [@"mediaserverd" isEqualToString:processName];
    isSpringboard = [@"SpringBoard" isEqualToString:processName];

    // Someone smarter than me invented this.
    // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
    bool shouldLoad = NO;
    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString *executablePath = args[0];
        if (executablePath) {
            NSString *processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip) || isMSD || isSpringboard) {
                shouldLoad = YES;
            }
        }
    }

    if (!shouldLoad) return;

    HBCBPreferencesChanged();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)HBCBPreferencesChanged, (CFStringRef)BCNotification, NULL, kNilOptions);
    
    if (isSpringboard) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)BCSBCheckIsAppDisabled, (CFStringRef)BCNotificationAppChange, NULL, kNilOptions);
        NSLog(@"[BegoneCIA] Loaded - SB.");
        %init(BCSpringboard);
    } else if (isMSD) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)BCMSDDisable, (CFStringRef)BCNotificationMSDDisable, NULL, kNilOptions);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)BCMSDEnable, (CFStringRef)BCNotificationMSDEnable, NULL, kNilOptions);
        NSLog(@"[BegoneCIA] Loaded - msd.");
        %init(BCMSD);
    } else {
        CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, (CFNotificationCallback)BCAppChanged, (CFStringRef)UIApplicationDidBecomeActiveNotification, NULL, kNilOptions);
        NSLog(@"[BegoneCIA] Loaded - ui.");
        %init(BCEverythingElse);
    }
}