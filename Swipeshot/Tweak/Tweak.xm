@interface UIWindow(SS)

@property (nonatomic, retain) UIPanGestureRecognizer *ssGestureRecognizer;
- (void)ssEnable;
- (void)ssScreenshot;

@end

@interface SBWindow : UIWindow

@end

@interface SpringBoard

-(void)takeScreenshot;
-(void)takeScreenshotAndEdit:(BOOL)arg1 ;

@end

BOOL dpkgInvalid = false;
BOOL isSpringboard;
SpringBoard *sb = nil;

void takeScreenshot() {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [sb takeScreenshot];
    });
}

%group SwipeshotSB

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (!dpkgInvalid) {
        sb = self;
        return;
    }

    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of Swipeshot you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Swipeshot is free. Uninstall this build and install the proper version of Swipeshot from:\nhttps://repo.nepeta.me/\n(it's free, damnit, why would you pirate that!?)"
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Damn!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [((UIApplication*)self).keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    }]];

    [((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end

%end

%group Swipeshot

%hook SBWindow

- (id)initWithFrame:(CGRect)frame {
    %orig;
    [self ssEnable];
    return self;
}

-(id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5 {
    %orig;
    [self ssEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 {
    %orig;
    [self ssEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 debugName:(id)arg2 rootViewController:(id)arg3 {
    %orig;
    [self ssEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 scene:(id)arg4 {
    %orig;
    [self ssEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 debugName:(id)arg2 {
    self = %orig;
    [self ssEnable];
    return self;
}

%end

%hook UIWindow

%property (nonatomic, retain) UIPanGestureRecognizer *ssGestureRecognizer;

%new
- (void)ssScreenshot {
    if (self.ssGestureRecognizer.state != UIGestureRecognizerStateBegan) return;
    if (isSpringboard) {
        [sb takeScreenshot];
    } else {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.swipeshot/TakeScreenshot", nil, nil, true);
    }
}

%new
- (void)ssEnable {
    if (self.ssGestureRecognizer) return;
    self.ssGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ssScreenshot)];
    self.ssGestureRecognizer.minimumNumberOfTouches = 3;
    self.ssGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:self.ssGestureRecognizer];
}

- (id)initWithFrame:(CGRect)frame {
    %orig;
    [self ssEnable];
    return self;
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
            return;
        }
    }

    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.swipeshot.list"];
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
            if ((!isFileProvider && isApplication && !skip) || isSpringboard) {
                shouldLoad = YES;
            }
        }
    }

    if (!shouldLoad) return;

    if (isSpringboard) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)takeScreenshot, (CFStringRef)@"me.nepeta.swipeshot/TakeScreenshot", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
        %init(SwipeshotSB);
    }

    if (!dpkgInvalid) %init(Swipeshot);
}