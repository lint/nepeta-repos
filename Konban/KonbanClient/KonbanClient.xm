#import "KonbanClient.h"
#import <Cephei/HBPreferences.h>

BOOL enabled;
BOOL hideStatusBar;
HBPreferences *preferences;
NSString *bundleID = @"com.apple.calculator";
BOOL konbanHidden = NO;
UIView *statusBar = nil;

void changeApp() {
    NSMutableDictionary *appList = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.nepeta.konban-app.plist"];
    if (!appList) return;
    
    if ([appList objectForKey:@"App"]) {
        bundleID = [appList objectForKey:@"App"];
    }
}

void konHideStatusBar() {
    if (!enabled || !hideStatusBar) return;
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleIdentifier isEqualToString:bundleID]) {
        konbanHidden = YES;
        [statusBar setHidden:YES];
    }
}

void konShowStatusBar() {
    if (!enabled || !hideStatusBar) return;
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleIdentifier isEqualToString:bundleID]) {
        konbanHidden = NO;
        [statusBar setHidden:NO];
    }
}

%hook UIStatusBar

-(id)_initWithFrame:(CGRect)arg1 showForegroundView:(BOOL)arg2 inProcessStateProvider:(id)arg3 {
    %orig;
    statusBar = (UIView *)self;
    return self;
}

-(void)layoutSubviews {
    %orig;
    if (konbanHidden) [self setHidden:YES];
    statusBar = (UIView *)self;
}

%end

%hook _UIStatusBar

-(id)initWithStyle:(long long)arg1 {
    %orig;
    statusBar = (UIView *)self;
    return self;
}

-(void)layoutSubviews {
    %orig;
    if (konbanHidden) [self setHidden:YES];
    statusBar = (UIView *)self;
}

%end

%ctor{
    if (![NSProcessInfo processInfo]) return;
    NSString *processName = [NSProcessInfo processInfo].processName;
    bool isSpringboard = [@"SpringBoard" isEqualToString:processName];
    if (isSpringboard) return;

    // Someone smarter than me invented this.
    // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
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
            if (isFileProvider || !isApplication || skip) return;
        }
    }

    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.konban"];
    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerBool:&hideStatusBar default:YES forKey:@"HideStatusBar"];

    changeApp();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)changeApp, (CFStringRef)@"me.nepeta.konban/ReloadApp", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)konHideStatusBar, (CFStringRef)@"me.nepeta.konban/StatusBarHide", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)konShowStatusBar, (CFStringRef)@"me.nepeta.konban/StatusBarShow", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}