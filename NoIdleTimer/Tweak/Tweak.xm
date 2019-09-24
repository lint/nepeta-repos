#import <Cephei/HBPreferences.h>
#import "Tweak.h"

HBPreferences *preferences;
bool disableForMedia;
bool disableForCharging;

%group NoIdleTimer

%hook SBDashBoardIdleTimerProvider

-(bool)isIdleTimerEnabled {
    if (disableForCharging) {
        SBUIController *controller = [%c(SBUIController) sharedInstanceIfExists];
        if (controller && [controller isOnAC]) return false;
    }

    if (disableForMedia) {
        SBMediaController *controller = [%c(SBMediaController) sharedInstance];
        if (controller && [controller isPlaying]) return false;
    }

    return %orig;
}

%end

%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.noidletimer"];
    [preferences registerDefaults:@{
        @"DisableForMedia": @NO,
        @"DisableForCharging": @NO,
    }];

    [preferences registerBool:&disableForMedia default:NO forKey:@"DisableForMedia"];
    [preferences registerBool:&disableForCharging default:NO forKey:@"DisableForCharging"];

    %init(NoIdleTimer);
}
