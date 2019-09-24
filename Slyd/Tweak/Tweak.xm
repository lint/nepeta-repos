#import "Tweak.h"

/* Config */
HBPreferences *preferences;
BOOL dpkgInvalid = false;
BOOL enabled;
BOOL showChevron;
BOOL disableHome;
BOOL disableSwipe;
NSInteger appearance; // 0 - auto; 1 - light; 2 - dark
NSString *text;

/* Random stuff to keep track of */
static SBPagedScrollView *psv = nil;
static SBDashBoardMainPageView *sdbmpv = nil;
static SBDashBoardTodayContentView *sdbtcv = nil;
static SBDashBoardFixedFooterViewController *sdbffvc = nil;
static SBDashBoardTeachableMomentsContainerViewController *sdbtmcvc = nil;
static SBDashBoardViewController *sbdbvc = nil;
static bool preventHome = false;
static bool isOnLockscreen = true;
static bool canUnlock = false;

static SBDashBoardPasscodeViewController *passController;

void setIsOnLockscreen(bool isIt) {
    isOnLockscreen = isIt;
    preventHome = false;
    canUnlock = false;
    [sdbmpv stuStateChanged];
    [sdbtcv stuStateChanged];
    [sdbffvc stuStateChanged];
    [sdbtmcvc stuStateChanged];
}

%group SlideToUnlock

%hook SBDashBoardMainPageView

%property (nonatomic, retain) _UIGlintyStringView *stuGlintyStringView;

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    sdbmpv = self;
    return orig;
}

-(void)layoutSubviews {
    %orig;
    if (!self.stuGlintyStringView) {
        self.stuGlintyStringView = [[_UIGlintyStringView alloc] initWithText:text andFont:[UIFont systemFontOfSize:25]];
    }

    [self stuStateChanged];
}

%new;
-(void)stuStateChanged {
    if (isOnLockscreen && enabled) {
        [self addSubview:self.stuGlintyStringView];
        self.stuGlintyStringView.frame = CGRectMake(0, self.frame.size.height - 150, self.frame.size.width, 150);
        [self sendSubviewToBack:self.stuGlintyStringView];
        if (showChevron) {
            [self.stuGlintyStringView setChevronStyle:1];
        } else {
            [self.stuGlintyStringView setChevronStyle:0];
        }

        [self.stuGlintyStringView hide];
        [self.stuGlintyStringView show];
        
        UIColor *primaryColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0];
        if (appearance == 0 && sbdbvc && [sbdbvc legibilitySettings]) {
            CGFloat white = 0;
            CGFloat alpha = 0;
            [[sbdbvc legibilitySettings].primaryColor getWhite:&white alpha:&alpha];
            if (white == 1) primaryColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
        } else if (appearance == 1) {
            primaryColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
        }

        self.stuGlintyStringView.layer.sublayers[0].sublayers[2].backgroundColor = [primaryColor colorWithAlphaComponent:0.65].CGColor;
    } else {
        [self.stuGlintyStringView hide];
        [self.stuGlintyStringView removeFromSuperview];
    }
}

%end

%hook SBUIPasscodeLockNumberPad

-(void)_cancelButtonHit {
    %orig;
    if (psv && enabled) {
        preventHome = true;
        [psv scrollToPageAtIndex:1 animated:true];
    }
}

%end

%hook SBPagedScrollView

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    psv = self;
    return orig;
}

// Only unlocks on finger release
- (void)_bs_didEndScrolling {
    %orig;
    if (self.currentPageIndex == 0 && self.pageRelativeScrollOffset < 0.50
            && !preventHome && isOnLockscreen && enabled) {
        preventHome = true;
        canUnlock = true;
        [[%c(SBLockScreenManager) sharedInstance] lockScreenViewControllerRequestsUnlock];
    }

    if (self.currentPageIndex != 0) {
        preventHome = false;
    }
}

-(void)setCurrentPageIndex:(NSUInteger)idx {
    %orig;
}

%end

%hook SBCoverSheetPrimarySlidingViewController

-(void)_handleDismissGesture:(id)arg1 {
    if (enabled && isOnLockscreen && disableSwipe) {
        return;
    }

    %orig;
}

-(void)setPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3 {
    if (enabled && isOnLockscreen && disableHome && !arg1 && !canUnlock) {
        return;
    }

    %orig;
}

%end

/* Bloat remover */

%hook SBDashBoardTodayContentView

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    sdbtcv = self;
    return orig;
}

-(void)layoutSubviews {
    %orig;
    [self stuStateChanged];
}

%new;
-(void)stuStateChanged {
    if (isOnLockscreen && enabled) {
        self.alpha = 0.0;
        self.hidden = YES;
    } else {
        self.alpha = 1.0;
        self.hidden = NO;
    }
}

%end

%hook SBDashBoardTodayPageViewController
/* Blurry dark passcode page background */
-(long long)backgroundStyle  {
    if (isOnLockscreen && enabled) {
        return 6;
    } else {
        return %orig;
    }
}

-(void)aggregateAppearance:(id)arg1 {
    %orig;
    if (!enabled) return;

    /* Move time/date with slide to unlock */
    if (isOnLockscreen) {
        SBDashBoardComponent *dateView = [[%c(SBDashBoardComponent) dateView] hidden:YES];
        [arg1 addComponent:dateView];
    }

    if (!passController) {
        passController = [[%c(SBDashBoardPasscodeViewController) alloc] init];
        passController.title = @"Slyd";
        [self.view addSubview:passController.view];
        passController.view.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        MSHookIvar<UIView *>(passController, "_backgroundView").hidden = YES;
        [self addChildViewController:passController];
        [passController didMoveToParentViewController:self];
    }
    if (isOnLockscreen && MSHookIvar<NSUInteger>([%c(SBLockStateAggregator) sharedInstance], "_lockState") == 3) {
        passController.view.hidden = NO;
        [passController performCustomTransitionToVisible:true withAnimationSettings:nil completion:nil];
    } else {
        passController.view.hidden = YES;
    }
}

%end

%hook SBDashBoardPasscodeViewController

-(void)performCustomTransitionToVisible:(BOOL)arg1 withAnimationSettings:(id)arg2 completion:(/*^block*/id)arg3 { 
    if (enabled && ![self.title isEqualToString:@"Slyd"]) {
        arg1 = false;
        [self.view removeFromSuperview];
    }
    %orig;
}

%end

%hook SBDashBoardFixedFooterViewController

-(id)init {
    id orig = %orig;
    sdbffvc = self;
    return orig;
}

-(void)viewDidLoad{
    %orig;
    [self stuStateChanged];
}

%new;
-(void)stuStateChanged {
    if (enabled) {
        self.view.alpha = 0.0;
        self.view.hidden = YES;
    } else {
        self.view.alpha = 1.0;
        self.view.hidden = NO;
    }
}

%end

%hook SBDashBoardTeachableMomentsContainerViewController

-(id)init {
    id orig = %orig;
    sdbtmcvc = self;
    return orig;
}

-(void)viewDidLoad{
    %orig;
    [self stuStateChanged];
}

%new;
-(void)stuStateChanged {
    if (enabled) {
        self.view.alpha = 0.0;
        self.view.hidden = YES;
    } else {
        self.view.alpha = 1.0;
        self.view.hidden = NO;
    }
}

%end

/* Check for unlock */

%hook SBDashBoardViewController

-(void)viewWillAppear:(BOOL)animated {
    %orig;

    setIsOnLockscreen(!self.authenticated);
}

-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 {
    id orig = %orig;
    sbdbvc = orig;
    return orig;
}

-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 legibilityProvider:(id)arg3  {
    id orig = %orig;
    sbdbvc = orig;
    return orig;
}

-(BOOL)isPasscodeLockVisible {
    if (!enabled) return %orig;
    return true;
}

%end

/* Force enable today view */

%hook SBMainDisplayPolicyAggregator

-(BOOL)_allowsCapabilityLockScreenTodayViewWithExplanation:(id*)arg1 {
    if (!enabled) return %orig;
    return true;
}

-(BOOL)_allowsCapabilityTodayViewWithExplanation:(id*)arg1 {
    if (!enabled) return %orig;
    return true;
}

%end

%end

%group SlydIntegrityFail

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (!dpkgInvalid) return;
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of Slyd you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Slyd is free. Uninstall this build and install the proper version of Slyd from:\nhttps://repo.nepeta.me/\n(it's free, damnit, why would you pirate that!?)"
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Damn!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [((UIApplication*)self).keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    }]];

    [((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end

%end

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    setIsOnLockscreen(true);
}

%ctor{
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.slyd.list"];

    if (dpkgInvalid) {
        %init(SlydIntegrityFail);
        return;
    }

    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.slyd"];

    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerBool:&showChevron default:YES forKey:@"ShowChevron"];
    [preferences registerBool:&disableHome default:YES forKey:@"DisableHome"];
    [preferences registerBool:&disableSwipe default:YES forKey:@"DisableSwipe"];
    [preferences registerInteger:&appearance default:0 forKey:@"Appearance"];
    [preferences registerObject:&text default:@"slide to unlock" forKey:@"Text"];

    [preferences registerPreferenceChangeBlock:^() {
        if (sdbmpv) {
            [sdbmpv.stuGlintyStringView setText:text];
            [sdbmpv.stuGlintyStringView setNeedsTextUpdate:true];
            [sdbmpv.stuGlintyStringView updateText];
        }

        setIsOnLockscreen(isOnLockscreen);
    }];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    %init(SlideToUnlock);
}
