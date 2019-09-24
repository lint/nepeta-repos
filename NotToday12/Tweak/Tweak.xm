#import "Tweak.h"

#ifndef SIMULATOR
HBPreferences *preferences;
#endif
bool enabled;
bool enabledCoverSheet;
bool enabledHomeScreen;

%group NotToday12

%hook SBMainDisplayPolicyAggregator

-(BOOL)_allowsCapabilityLockScreenTodayViewWithExplanation:(id*)arg1 {
    return !(enabled && enabledCoverSheet);
}

-(BOOL)_allowsCapabilityTodayViewWithExplanation:(id*)arg1 {
    return !(enabled && enabledCoverSheet);
}

%end

%hook SBRootFolderView

-(unsigned long long)_minusPageCount {
    return !(enabled && enabledHomeScreen);
}

-(void)_layoutSubviewsForTodayView {
    %orig;
    [self todayViewController].view.hidden = (enabled && enabledHomeScreen);
}

-(void)beginPageStateTransitionToState:(long long)arg1 animated:(BOOL)arg2 interactive:(BOOL)arg3  {
    if ((enabled && enabledHomeScreen) && arg1 == 2) return; // 0 - icons; 2 - today view; 3 - spotlight?
    %orig;
}

%end

%end

%ctor{
    NSLog(@"[NotToday12] init");
    #ifndef SIMULATOR
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.nottoday12"];
    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerBool:&enabledCoverSheet default:YES forKey:@"EnabledCoverSheet"];
    [preferences registerBool:&enabledHomeScreen default:YES forKey:@"EnabledHomeScreen"];
    #else
    enabled = YES;
    enabledCoverSheet = YES;
    enabledHomeScreen = YES;
    #endif
    %init(NotToday12);
}