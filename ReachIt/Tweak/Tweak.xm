#import <Cephei/HBPreferences.h>
#import <libcolorpicker.h>
#import "Tweak.h"

HBPreferences *preferences;

BOOL dpkgInvalid = false;
BOOL enabled;
NSInteger style;

%group ReachIt

%hook SBReachabilityBackgroundView

-(void)_setupChevron { }

%end

%hook SBReachabilityManager

- (void)_panToDeactivateReachability:(id)arg1 { 
    if (enabled && ![arg1 isKindOfClass:%c(SBScreenEdgePanGestureRecognizer)]) return;
    %orig;
}

- (_Bool)gestureRecognizerShouldBegin:(id)arg1 {
    if (enabled && (![arg1 isKindOfClass:%c(SBScreenEdgePanGestureRecognizer)] && ![arg1 isKindOfClass:%c(SBReachabilityGestureRecognizer)])) return false;
    return %orig;
}

- (void)_tapToDeactivateReachability:(id)arg1 { }

%end

%hook MPVolumeSlider

- (bool)isOnScreenForVolumeDisplay {
    if (enabled && ![[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive]) return false;
    return %orig;
}

%end

%hook SBReachabilityWindow

%property (nonatomic, retain) MediaControlsPanelViewController *ritMCPVC;
%property (nonatomic, retain) UIView *ritLastSeen;

-(void)layoutSubviews {
    %orig;
    if (!self.ritMCPVC) {
        UIView *view = self;
        view.userInteractionEnabled = YES;
        view.layer.masksToBounds = NO;
        view.clipsToBounds = NO;
        self.ritMCPVC = [%c(MediaControlsPanelViewController) panelViewControllerForCoverSheet];
        [self.ritMCPVC setStyle:style];
        CGFloat height = [[%c(SBReachabilityManager) sharedInstance] effectiveReachabilityYOffset];
        self.ritMCPVC.view.frame = CGRectMake(view.frame.origin.x, -height, view.frame.size.width, height);
        [view addSubview:self.ritMCPVC.view];
        [view bringSubviewToFront:self.ritMCPVC.view];
    }

    self.ritMCPVC.view.hidden = !enabled;

    if (self.ritMCPVC.style != style) [self.ritMCPVC setStyle:style];
}

-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 {
    if (!enabled) return %orig;
    UIView *candidate = %orig;
    
    if (arg1.y <= 0) {
        candidate = [self.ritMCPVC.view hitTest:[self.ritMCPVC.view convertPoint:arg1 fromView:self] withEvent:arg2];

        if (self.ritLastSeen) {
            candidate = self.ritLastSeen;
            self.ritLastSeen = nil;
        } else {
            self.ritLastSeen = candidate;
        }
    }

    return candidate;
}

%end

%hook SBFluidSwitcherViewController

%property (nonatomic, retain) MediaControlsPanelViewController *ritMCPVC;

-(void)viewWillAppear:(BOOL)arg1 {
    %orig;
    if (!self.ritMCPVC) {
        self.ritMCPVC = [%c(MediaControlsPanelViewController) panelViewControllerForCoverSheet];
        self.ritMCPVC.view.alpha = 0.0;
        [self.view addSubview:self.ritMCPVC.view];
    }

    self.ritMCPVC.view.hidden = !enabled;
    
    if (self.ritMCPVC.style != style) [self.ritMCPVC setStyle:style];
}

-(void)handleReachabilityModeActivated {
    %orig;
    self.ritMCPVC.view.hidden = !enabled;
    if (!enabled) return;

    double factor = 0.5;
    SBFluidSwitcherGestureManager *manager = [self valueForKey:@"_gestureManager"];
    if (manager && [manager reachabilitySettings]) factor = [manager reachabilitySettings].yOffsetFactor;

    self.ritMCPVC.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height * factor);

    [self.ritMCPVC setStyle:style];
    
    [UIView animateWithDuration:0.2 animations:^() {
        self.ritMCPVC.view.alpha = 1.0;
    }];
}

-(void)handleReachabilityModeDeactivated {
    %orig;
    if (!enabled) return;

    [UIView animateWithDuration:0.2 animations:^() {
        self.ritMCPVC.view.alpha = 0.0;
    }];
}

%end

%end

%group ReachItIntegrityFail

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (!dpkgInvalid) return;
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of ReachIt you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: ReachIt is free. Uninstall this build and install the proper version of ReachIt from:\nhttps://repo.nepeta.me/\n(it's free, damnit, why would you pirate that!?)"
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Damn!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [((UIApplication*)self).keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    }]];

    [((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end

%end

%ctor {
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.reachit.list"];

    if (dpkgInvalid) {
        %init(ReachItIntegrityFail);
        return;
    }

    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.reachit"];

    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerInteger:&style default:1 forKey:@"Style"];

    %init(ReachIt);
}
