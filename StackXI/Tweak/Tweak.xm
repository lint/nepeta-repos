#import "Tweak.h"

#define kClear @"CLEAR"
#define kCollapse @"COLLAPSE"
#define kOneMoreNotif @"ONE_MORE_NOTIFICATION"
#define kMoreNotifs @"MORE_NOTIFICATIONS"
#define LANG_BUNDLE_PATH @"/Library/PreferenceBundles/StackXIPrefs.bundle/StackXILocalization.bundle"
#define MAX_SHOW_BEHIND 3 //amount of blank notifications to show behind each stack

extern dispatch_queue_t __BBServerQueue;

static SBDashBoardCombinedListViewController *sbdbclvc = nil;
static BBServer *bbServer = nil;
static NCNotificationPriorityList *priorityList = nil;
static NCNotificationListCollectionView *listCollectionView = nil;
static NCNotificationCombinedListViewController *clvc = nil;
static NCNotificationStore *store = nil;
static NCNotificationDispatcher *dispatcher = nil;
static SBDashBoardViewController *sbdbvc = nil;
static NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
static bool useIcons = false;
static bool canUpdate = true;
static bool isOnLockscreen = true;
static bool showClearAllButton = true;
static bool forceOldBehavior = false;
static bool enabled = true;
static bool remakeButtons = false;
static int showButtons = 2; // 0 - StackXI default; 1 - iOS 12
static int buttonWidth = 75;
static float animationMultiplier = 1.0;
static float animationDurationDefault = 0.2;
static float animationDurationClear = 0.3;
static int clearAllExpandedWidth = 100;
static int clearAllCollapsedWidth = 30;
static int clearAllHeight = 30;
static int clearAllImageWidth = 20; // 20 + 2*5 (inset)
static int clearAllButtonSpacing = 5;
static int buttonHeight = 25;
static int buttonSpacing = 5;
static int headerPadding = 0;
static int moreLabelHeight = 15;
static int groupBy = 0;
static int buttonIconStyle = 0;
static NSDictionary<NSString*, NSString*> *translationDict;
static SXITheme *currentTheme;
static NSArray *appsStackableByTitle = @[@"com.junecloud.Deliveries", @"com.google.hangouts", @"com.facebook.Messenger"]; //TODO: applist?

UIImage * imageWithView(UIView *view) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@implementation SXIButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.backdropView = [[_UIBackdropView alloc] initWithStyle:1000];

    self.backdropView.frame = self.bounds;
    self.backdropView.userInteractionEnabled = false;

    [self insertSubview:self.backdropView atIndex:0];

    self.overlayView = [[UIView alloc] init];
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
    [self addSubview:self.overlayView];

    self.button = [[UIButton alloc] init];
    self.button.frame = self.bounds;
    [self addSubview:self.button];

    self.button.imageView.tintColor = [UIColor blackColor];

    if (buttonIconStyle == 2) {
        self.button.imageView.tintColor = [UIColor whiteColor];
    }

    if (buttonIconStyle == 0) {
        self.button.layer.compositingFilter = @"destOut";
    }

    return self;
}

- (void)addBlurEffect {
    self.backdropView.frame = self.bounds;
    self.button.frame = self.bounds;
    self.overlayView.frame = self.bounds;
}

@end

static void fakeNotification(NSString *sectionID, NSDate *date, NSString *message, NSString *thread) {
    dispatch_sync(__BBServerQueue, ^{
        BBBulletin *bulletin = [[BBBulletin alloc] init];

        bulletin.title = @"StackXI";
        bulletin.message = message;
        bulletin.sectionID = sectionID;
        bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
        bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
        bulletin.threadID = NULL; //thread;
        bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
        bulletin.date = date;
        bulletin.defaultAction = [BBAction actionWithLaunchBundleID:sectionID callblock:nil];

        [bbServer publishBulletin:bulletin destinations:4 alwaysToLockScreen:YES];
    });
}

static void fakeNotifications() {
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 1!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 2!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 3!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 4!", @"AAAAA-AAAAB");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 5!", @"AAAAA-AAAAB");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 6!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 7!", @"AAAAA-AAAAB");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 8!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 9!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 10!", @"AAAAA-AAAAB");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 11!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 12!", @"AAAAA-AAAAA");
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test notification 13!", @"AAAAA-AAAAB");
    fakeNotification(@"com.apple.Music", [NSDate date], @"Test notification 14!", NULL);
    fakeNotification(@"com.apple.mobilephone", [NSDate date], @"Test notification 15!", NULL);
}

%group StackXIDebug


%hook BBServer
-(id)initWithQueue:(id)arg1 {
    bbServer = %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        fakeNotifications();
    });

    return bbServer;
}

-(id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 {
    bbServer = %orig;
    return bbServer;
}

- (void)dealloc {
  if (bbServer == self) {
    bbServer = nil;
  }

  %orig;
}
%end

%end

%group StackXI

%hook SBDashBoardCombinedListViewController

-(void)viewDidLoad{
    %orig;
    sbdbclvc = self;
}

%end


%hook NCNotificationListSectionRevealHintView

-(void)layoutSubviews{
    self.alpha = 0;
    self.hidden = YES;
    %orig;
}

%end

%hook NCNotificationRequest

%property (assign,nonatomic) BOOL sxiIsStack;
%property (assign,nonatomic) BOOL sxiIsExpanded;
%property (assign,nonatomic) BOOL sxiVisible;
%property (assign,nonatomic) NSUInteger sxiPositionInStack;
%property (nonatomic,retain) NSMutableOrderedSet *sxiStackedNotificationRequests;

-(id)init {
    id orig = %orig;
    self.sxiStackedNotificationRequests = [NSMutableOrderedSet new];
    self.sxiVisible = true;
    self.sxiIsStack = false;
    self.sxiIsExpanded = false;
    self.sxiPositionInStack = 0;
    return orig;
}

%new
-(void)sxiInsertRequest:(NCNotificationRequest *)request {
    [self.sxiStackedNotificationRequests addObject:request];
}

%new
-(NSString *)sxiStackID {
    if (groupBy == 1) {
        if (![self.threadIdentifier hasPrefix:@"req-"]) {
            return [NSString stringWithFormat:@"%@:%@", self.bulletin.sectionID, self.threadIdentifier];
        } else {
            if ([self.bulletin.title length] > 0 && [appsStackableByTitle containsObject:self.bulletin.sectionID]) {
                return [NSString stringWithFormat:@"%@:%@", self.bulletin.sectionID, self.bulletin.title];
            } else {
                return self.bulletin.sectionID;
            }
        }
    } else {
        return self.bulletin.sectionID;
    }
}

%new
-(void)sxiExpand {
    if (self.sxiIsExpanded) return;
    self.sxiIsExpanded = true;

    for (NCNotificationRequest *request in self.sxiStackedNotificationRequests) {
        request.sxiVisible = true;
    }

    [listCollectionView sxiExpand:[self sxiStackID]];
}


%new
-(void)sxiCollapse {
    if (!self.sxiIsExpanded) return;
    self.sxiIsExpanded = false;

    for (NCNotificationRequest *request in self.sxiStackedNotificationRequests) {
        request.sxiVisible = false;
    }

    [listCollectionView sxiCollapse:[self sxiStackID]];
}

%new
-(void)sxiClear:(BOOL)reload {
    if (!self.notificationIdentifier || !self.bulletin) return;
    
    if (reload) {
        canUpdate = false;
    }
    [priorityList removeNotificationRequest:self];
    //[self.clearAction.actionRunner executeAction:self.clearAction fromOrigin:self withParameters:nil completion:nil]; - TODO: check if this helps sometimes
    [dispatcher destination:nil requestsClearingNotificationRequests:@[self]];
    [listCollectionView sxiClear:self.notificationIdentifier];
    if (reload) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (animationDurationClear*animationMultiplier) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            canUpdate = true;
            [listCollectionView reloadData];
        });
    }
}

%new
-(void)sxiClearStack {
    canUpdate = false;
    for (NCNotificationRequest *request in self.sxiStackedNotificationRequests) {
        [request sxiClear:false];
    }

    [self sxiClear:false];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (animationDurationClear*animationMultiplier) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        canUpdate = true;
        [listCollectionView reloadData];
    });
}

%end


%hook NCNotificationSectionList

-(id)removeNotificationRequest:(id)arg1 {
    //[priorityList removeNotificationRequest:(NCNotificationRequest *)arg1];
    return nil;
}

-(id)insertNotificationRequest:(id)arg1 {
    [priorityList insertNotificationRequest:(NCNotificationRequest *)arg1];
    return nil;
}

-(NSUInteger)sectionCount {
    return 0;
}

-(NSUInteger)rowCountForSectionIndex:(NSUInteger)arg1 {
    return 0;
}

-(id)notificationRequestsForSectionIdentifier:(id)arg1 {
    return nil;
}

-(id)notificationRequestsAtIndexPaths:(id)arg1 {
    return nil;
}

%end

%hook NCNotificationChronologicalList

-(id)removeNotificationRequest:(id)arg1 {
    //[priorityList removeNotificationRequest:(NCNotificationRequest *)arg1];
    return nil;
}

-(id)insertNotificationRequest:(id)arg1 {
    [priorityList insertNotificationRequest:(NCNotificationRequest *)arg1];
    return nil;
}

%end

%hook NCNotificationPriorityList

%property (nonatomic,retain) NSMutableOrderedSet* sxiAllRequests;

-(id)init {
    NSLog(@"[StackXI] Init!");
    id orig = %orig;
    priorityList = self;
    self.sxiAllRequests = [NSMutableOrderedSet new];
    return orig;
}

%new
-(void)sxiUpdateList {
    if (!canUpdate) return;
    [self.requests removeAllObjects];

    NSMutableDictionary* stacks = [NSMutableDictionary new];

    for (int i = 0; i < [self.sxiAllRequests count]; i++) {
        NCNotificationRequest *req = self.sxiAllRequests[i];
        if (req.bulletin && req.bulletin.sectionID && req.timestamp && req.options && req.options.lockScreenPriority) {
            NSString *stackID = [req sxiStackID];
            if (stacks[stackID]) {
                if ([req.timestamp compare:stacks[stackID][@"timestamp"]] == NSOrderedDescending) {
                    stacks[stackID] = @{
                        @"timestamp" : req.timestamp,
                        @"priority" : stacks[stackID][@"priority"]
                    };
                }
                if (req.options.lockScreenPriority > [stacks[stackID][@"priority"] longValue]) {
                    stacks[stackID] = @{
                        @"timestamp" : stacks[stackID][@"timestamp"],
                        @"priority" : @(req.options.lockScreenPriority)
                    };
                }
            } else {
                stacks[stackID] = @{
                    @"timestamp" : req.timestamp,
                    @"priority" : @(req.options.lockScreenPriority)
                };
            }
        }
    }

    [self.sxiAllRequests sortUsingComparator:(NSComparator)^(id obj1, id obj2){
        NCNotificationRequest *a = (NCNotificationRequest *)obj1;
        NCNotificationRequest *b = (NCNotificationRequest *)obj2;
        NSString *stackIDa = [a sxiStackID];
        NSString *stackIDb = [b sxiStackID];

        if ([stackIDa isEqualToString:stackIDb]) {
            return [b.timestamp compare:a.timestamp] == NSOrderedDescending;
        }

        if (stackIDb && stackIDa && stacks[stackIDb] && stacks[stackIDa]) {
            if ([stacks[stackIDb][@"priority"] compare:stacks[stackIDa][@"priority"]] == NSOrderedSame) {
                return [stacks[stackIDb][@"timestamp"] compare:stacks[stackIDa][@"timestamp"]] == NSOrderedDescending;
            }
            return [stacks[stackIDb][@"priority"] compare:stacks[stackIDa][@"priority"]] == NSOrderedDescending;
        }

        return [stackIDb localizedStandardCompare:stackIDb] == NSOrderedAscending;
    }];

    NSString *expandedSection = nil;

    for (int i = 0; i < [self.sxiAllRequests count]; i++) {
        NCNotificationRequest *req = self.sxiAllRequests[i];
        if (req.bulletin.sectionID && req.sxiIsExpanded && req.sxiIsStack) {
            expandedSection = [req sxiStackID];
            break;
        }
    }

    NSString *lastSection = nil;
    NCNotificationRequest *lastStack = nil;
    NSUInteger sxiPositionInStack = 0;

    for (int i = 0; i < [self.sxiAllRequests count]; i++) {
        NCNotificationRequest *req = self.sxiAllRequests[i];
        bool shouldBelongOnLockscreen = [req.requestDestinations containsObject:@"BulletinDestinationLockScreen"] || forceOldBehavior;
        if (isOnLockscreen && !shouldBelongOnLockscreen) {
            continue;
        }

        if (req.bulletin.sectionID) {
            NSString *stackID = [req sxiStackID];

            [req.sxiStackedNotificationRequests removeAllObjects];
            req.sxiIsStack = false;
            req.sxiVisible = false;
            req.sxiIsExpanded = false;
            req.sxiPositionInStack = ++sxiPositionInStack;

            if ([expandedSection isEqualToString:stackID]) {
                req.sxiVisible = true;
            }

            if (!lastSection || ![lastSection isEqualToString:stackID]) {
                lastSection = stackID;
                lastStack = req;

                req.sxiVisible = true;
                req.sxiIsStack = true;
                req.sxiPositionInStack = 0;
                sxiPositionInStack = 0;
                if ([expandedSection isEqualToString:stackID]) {
                    req.sxiIsExpanded = true;
                }

                [self.requests addObject:req];

                continue;
            }

            if (lastStack && [lastSection isEqualToString:stackID]) {
                [lastStack sxiInsertRequest:req];
            }

            if (req.sxiPositionInStack <= MAX_SHOW_BEHIND || [expandedSection isEqualToString:stackID]) {
                [self.requests addObject:req];
            }
        } else {
            req.sxiVisible = true;
            req.sxiIsStack = true;
            req.sxiIsExpanded = false;
            req.sxiPositionInStack = 0;

            [self.requests addObject:req];
        }
    }
}

-(NSUInteger)insertNotificationRequest:(NCNotificationRequest *)request {
    if (!request || !request.notificationIdentifier) return 0;
    bool found = false;

    for (int i = 0; i < [self.sxiAllRequests count]; i++) {
        NCNotificationRequest *req = self.sxiAllRequests[i];
        if ([req.notificationIdentifier isEqualToString:request.notificationIdentifier]) {
            found = true;
            [self.sxiAllRequests replaceObjectAtIndex:(NSUInteger)i withObject:request];
            break;
        }
    }

    if (!found) {
        %orig;
        clvc.sxiClearAllConfirm = false;
        [clvc sxiUpdateClearAllButton];

        request.sxiVisible = true;
        [self.sxiAllRequests addObject:request];
        [listCollectionView reloadData];
    }
    return 0;
}

-(NSUInteger)removeNotificationRequest:(NCNotificationRequest *)request {
    if (!request) return 0;

    if (request.notificationIdentifier) {
        for (int i = 0; i < [self.sxiAllRequests count]; i++) {
            NCNotificationRequest *req = self.sxiAllRequests[i];
            if ([req.notificationIdentifier isEqualToString:request.notificationIdentifier]) {
                [self.sxiAllRequests removeObjectAtIndex:i];
            }
        }
    }

    clvc.sxiClearAllConfirm = false;
    [clvc sxiUpdateClearAllButton];
    [self.sxiAllRequests removeObject:request];
    [listCollectionView reloadData];
    return 0;
}

-(id)_clearRequestsWithPersistence:(unsigned long long)arg1 {
    return nil;
}

-(id)clearNonPersistentRequests {
    return nil;
}

-(id)clearRequestsPassingTest:(id)arg1 {
    //it removes notifications on unlock/lock :c
    //so i had to disable this
    return nil;
}

-(id)clearAllRequests {
    //not sure if i want this working too :D
    return nil;
}

%new
-(void)sxiClearAll {
    canUpdate = false;
    NSMutableArray *temp = [NSMutableArray new];
    for (NCNotificationRequest *req in self.sxiAllRequests) {
        if (req && req.bulletin && req.notificationIdentifier) {
            [temp addObject:req];
        }
    }
    [dispatcher destination:nil requestsClearingNotificationRequests:temp];
    [self.sxiAllRequests removeAllObjects];
    [listCollectionView sxiClearAll];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (animationDurationClear*animationMultiplier) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        canUpdate = true;
        [listCollectionView reloadData];
    });

    clvc.sxiClearAllConfirm = false;
    [clvc sxiUpdateClearAllButton];
}

%end

%hook NCNotificationListViewController

-(void)clearAllNonPersistent {
    // nothing
}

-(BOOL)hasVisibleContent {
    return [priorityList.requests count] > 0;
}

%end

%hook NCNotificationCombinedListViewController

%property (retain) SXIButton* sxiClearAllButton;
%property (retain) UINotificationFeedbackGenerator* sxiFeedbackGenerator;
%property (assign,nonatomic) BOOL sxiClearAllConfirm;
%property (assign,nonatomic) BOOL sxiIsLTR;
%property (assign,nonatomic) BOOL sxiGRAdded;

-(id)init {
    id orig = %orig;
    clvc = self;
    return orig;
}

-(void)scrollViewWillBeginDragging:(id)arg1 {
    %orig;
    if (self.sxiClearAllButton && self.sxiClearAllConfirm) {
        self.sxiClearAllConfirm = false;
        [self sxiUpdateClearAllButton];
    }
}

%new
-(CGRect)sxiGetClearAllButtonFrame {
    int width = clearAllCollapsedWidth;
    if (self.sxiClearAllConfirm) {
        width = clearAllExpandedWidth;
    }
    if (self.sxiIsLTR) {
        return CGRectMake(self.view.frame.size.width - (2*clearAllButtonSpacing) - width, -(clearAllHeight + clearAllButtonSpacing*3), width, clearAllHeight);
    } else {
        return CGRectMake((2*clearAllButtonSpacing), -(clearAllHeight + clearAllButtonSpacing*3), width, clearAllHeight);
    }
}

-(void)clearAllNonPersistent {
    // nothing
}

/*-(BOOL)hasContent {
    return true;
}*/

-(void)viewDidLayoutSubviews {
    %orig;

    if (listCollectionView) {
        CGRect frame = listCollectionView.frame;
        if (showClearAllButton) {
            listCollectionView.frame = CGRectMake(frame.origin.x, clearAllHeight + clearAllButtonSpacing*3, frame.size.width, frame.size.height);
        } else {
            listCollectionView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
        }
    }

    if (!self.sxiGRAdded) {
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sxiHandleGesture:)];
        gr.numberOfTapsRequired = 0;
        [self.view addGestureRecognizer:gr];

        self.sxiGRAdded = true;
    }

    self.sxiIsLTR = true;
    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.sxiIsLTR = false;
    }

    if (!self.sxiClearAllButton) {
        [self sxiMakeClearAllButton];
    }

    [self sxiUpdateClearAllButton];

    [self.view.subviews[0] bringSubviewToFront:self.sxiClearAllButton];
}

%new;
-(void)sxiHandleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.sxiClearAllButton || !self.sxiClearAllConfirm) return;

    CGPoint p = [gestureRecognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.sxiClearAllButton.frame, p)) {
        self.sxiClearAllConfirm = false;
        [self sxiUpdateClearAllButton];
    }
}

%new;
-(void)sxiMakeClearAllButton {
    if (!self.sxiFeedbackGenerator) {
        self.sxiFeedbackGenerator = [UINotificationFeedbackGenerator new];
    }
    self.sxiClearAllButton = [[SXIButton alloc] initWithFrame:[self sxiGetClearAllButtonFrame]];
    [self.sxiClearAllButton.button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    self.sxiClearAllButton.hidden = NO;
    self.sxiClearAllButton.alpha = 1.0;
    [self.sxiClearAllButton.button setTitle:[translationDict objectForKey:kClear] forState: UIControlStateNormal];
    //self.sxiClearAllButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [self.sxiClearAllButton.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sxiClearAllButton.layer.masksToBounds = true;
    self.sxiClearAllButton.layer.cornerRadius = clearAllHeight/2.0;
    self.sxiClearAllButton.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.sxiClearAllButton addBlurEffect];

    [self.sxiClearAllButton.button addTarget:self action:@selector(sxiClearAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.subviews[0] addSubview:self.sxiClearAllButton];

    float inset = 5.0;
    self.sxiClearAllButton.button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.sxiClearAllButton.button.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);

    self.sxiClearAllButton.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.sxiClearAllButton.button setTitle:NULL forState:UIControlStateNormal];
    UIImage *btnClearAllImage = [currentTheme getIcon:@"SXIClearAll.png"];
    [self.sxiClearAllButton.button setImage:btnClearAllImage forState:UIControlStateNormal];
    self.sxiClearAllButton.tintColor = [UIColor blackColor];

    self.sxiClearAllConfirm = false;
}

%new;
-(void)sxiUpdateClearAllButton {
    if (!self.sxiClearAllButton) {
        return;
    }

    if (![self hasContent] || !showClearAllButton) {
        [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.sxiClearAllButton.alpha = 0.0;
        } completion:NULL];
        return;
    } else {
        [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.sxiClearAllButton.alpha = 1.0;
        } completion:NULL];
    }

    float inset = 5.0;
    UIEdgeInsets insets = UIEdgeInsetsMake(inset, inset, inset, clearAllExpandedWidth - clearAllImageWidth - 2*inset);
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, (-clearAllExpandedWidth + clearAllImageWidth)/2, 0, 0);
    if (!self.sxiClearAllConfirm) {
        insets = UIEdgeInsetsMake(inset, inset, inset, inset);
        titleInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (!self.sxiIsLTR) {
        insets = UIEdgeInsetsMake(inset, clearAllExpandedWidth - clearAllImageWidth - 2*inset, inset, inset);
        titleInsets = UIEdgeInsetsMake(0, 0, 0, (-clearAllExpandedWidth + clearAllImageWidth)/2);
    }

    [self.sxiClearAllButton.button.titleLabel setTextAlignment:NSTextAlignmentCenter];

    [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.sxiClearAllButton.frame = [self sxiGetClearAllButtonFrame];
        
        self.sxiClearAllButton.backdropView.frame = self.sxiClearAllButton.bounds;
        self.sxiClearAllButton.button.frame = self.sxiClearAllButton.bounds;
        self.sxiClearAllButton.overlayView.frame = self.sxiClearAllButton.bounds;

        self.sxiClearAllButton.button.imageEdgeInsets = insets;
        self.sxiClearAllButton.button.titleEdgeInsets = titleInsets;
    } completion:NULL];
}

%new;
-(void)sxiClearAll:(UIButton *)button {
    if (!self.sxiClearAllConfirm) {
        [self.sxiClearAllButton.button setTitle:[translationDict objectForKey:kClear] forState: UIControlStateNormal];
        self.sxiClearAllConfirm = true;
        [self sxiUpdateClearAllButton];
        [self.sxiFeedbackGenerator prepare];
    } else {
        [self.sxiClearAllButton.button setTitle:NULL forState: UIControlStateNormal];
        [self _clearAllPriorityListNotificationRequests];
        [self.sxiFeedbackGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
    }
}

-(void)viewWillAppear:(bool)animated {
    [listCollectionView sxiCollapseAll];
    self.sxiClearAllConfirm = false;
    [self sxiUpdateClearAllButton];
    %orig;
}

-(void)viewWillDisappear:(bool)animated {
    [listCollectionView sxiCollapseAll];
    self.sxiClearAllConfirm = false;
    [self sxiUpdateClearAllButton];
    %orig;
}

-(NSInteger)numberOfSectionsInCollectionView:(id)arg1 {
    return 1;
}

-(NSInteger)collectionView:(id)arg1 numberOfItemsInSection:(NSInteger)arg2 {
    if (arg2 != 0) {
        return 0;
    }

    return %orig;
}

-(NCNotificationListCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return nil;
    }

    NCNotificationRequest* request = [self.notificationPriorityList.requests objectAtIndex:indexPath.row];
    if (!request) {
        NSLog(@"[StackXI] request is gone");
        return nil;
    }

    NCNotificationListCell* cell = %orig;

    if (!cell.contentViewController.notificationRequest.sxiVisible) {
        if (cell.contentViewController.notificationRequest.sxiPositionInStack > MAX_SHOW_BEHIND) {
            cell.hidden = YES;
        } else {
            cell.hidden = NO;
            if (cell.frame.size.height != 50) {
                cell.frame = CGRectMake(cell.frame.origin.x + (10 * cell.contentViewController.notificationRequest.sxiPositionInStack), cell.frame.origin.y - 50, cell.frame.size.width - (20 * cell.contentViewController.notificationRequest.sxiPositionInStack), 50);
            }
        }
    } else {
        cell.hidden = NO;
    }

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        return CGSizeZero;
    }

    CGSize orig = %orig;
    if (indexPath.section == 0) {
        NCNotificationRequest *request = [self.notificationPriorityList.requests objectAtIndex:indexPath.row];
        if (!request.sxiVisible) {
            if (request.sxiPositionInStack > MAX_SHOW_BEHIND) {
                return CGSizeMake(orig.width,0);
            } else {
                return CGSizeMake(orig.width,1);
            }
        }
        if (request.sxiIsStack) {
            if (!request.sxiIsExpanded && [request.sxiStackedNotificationRequests count] > 0) {
                return CGSizeMake(orig.width,orig.height + moreLabelHeight);
            }

            if (request.sxiIsExpanded && showButtons == 2) {
                int offset = buttonHeight + buttonSpacing*3;
                return CGSizeMake(orig.width,orig.height + offset);
            }
        }
    }
    return orig;
}

-(void)_clearAllPriorityListNotificationRequests {
    [priorityList sxiClearAll];
}

-(void)_clearAllSectionListNotificationRequests {
    //[priorityList sxiClearAll];
}

-(void)_moveNotificationRequestsToHistorySectionPassingTest:(/*^block*/id)arg1 animated:(BOOL)arg2 movedAll:(BOOL)arg3 {
    //do nothing
}

-(BOOL)modifyNotificationRequest:(NCNotificationRequest*)arg1 forCoalescedNotification:(id)arg2 {
    [priorityList insertNotificationRequest:arg1];
    return true;
}

%end

%hook NCNotificationListCell

%property (nonatomic,assign) BOOL sxiReturnSVToOrigFrame;
%property (nonatomic,assign) CGRect sxiSVOrigFrame;

-(void)layoutSubviews {
    /*//NSLog(@"[StackXI] SUBVIEWS!!!!");
    if (self.contentViewController.notificationRequest.sxiIsStack && !self.contentViewController.notificationRequest.sxiIsExpanded) {
        //NSLog(@"[StackXI] STACK CELL!!!!");
        [self.rightActionButtonsView.defaultActionButton setTitle: @"Clear All"];
        [self.rightActionButtonsView.defaultActionButton.titleLabel setText: @"Clear All"];
    } else {
        [self.rightActionButtonsView.defaultActionButton setTitle: @"Clear"];
        [self.rightActionButtonsView.defaultActionButton.titleLabel setText: @"Clear"];
    }*/

    int offset = buttonHeight + buttonSpacing*3;
    if (showButtons == 2) {
        NCNotificationShortLookViewController *controller = (NCNotificationShortLookViewController *)self.contentViewController;

        CGRect svFrame = controller.scrollView.frame;
        if (self.sxiReturnSVToOrigFrame && !controller.notificationRequest.sxiIsExpanded) {
            self.sxiReturnSVToOrigFrame = false;
            self.sxiSVOrigFrame = controller.scrollView.frame;
            controller.scrollView.frame = CGRectMake(svFrame.origin.x, svFrame.origin.y - offset, svFrame.size.width, svFrame.size.height + offset);
        }

        if (!self.sxiReturnSVToOrigFrame && controller.notificationRequest.sxiIsExpanded) {
            self.sxiReturnSVToOrigFrame = true;
            controller.scrollView.frame = CGRectMake(svFrame.origin.x, svFrame.origin.y + offset, svFrame.size.width, svFrame.size.height - offset);
        }
    }

    %orig;

    if (!self.contentViewController.notificationRequest.sxiIsStack) {
        [listCollectionView sendSubviewToBack:self];
    }
}

-(void)cellClearButtonPressed:(id)arg1 {
    [self _executeClearAction];
}

-(void)_executeClearAction {
    if (self.contentViewController.notificationRequest.sxiIsStack && !self.contentViewController.notificationRequest.sxiIsExpanded) {
        [self.contentViewController.notificationRequest sxiClearStack];
        return;
    }

    [self.contentViewController.notificationRequest sxiClear:true];
}

%end

%hook NCNotificationDispatcher

-(id)init {
    id orig = %orig;
    dispatcher = self;
    return orig;
}

-(id)initWithAlertingController:(id)arg1 {
    id orig = %orig;
    dispatcher = self;
    return orig;
}

%end

%hook NCNotificationStore

-(id)init {
    id orig = %orig;
    store = self;
    return orig;
}

-(id)insertNotificationRequest:(NCNotificationRequest*)arg1 {
    [priorityList insertNotificationRequest:arg1];
    return %orig;
}

-(id)removeNotificationRequest:(NCNotificationRequest*)arg1 {
    [priorityList removeNotificationRequest:arg1];
    return %orig;
}

-(id)replaceNotificationRequest:(NCNotificationRequest*)arg1 {
    [priorityList insertNotificationRequest:arg1];
    return %orig;
}

%end

%hook NCNotificationShortLookViewController

%property (retain) UILabel* sxiNotificationCount;
%property (retain) UILabel* sxiTitle;
%property (retain) SXIButton* sxiClearAllButton;
%property (retain) SXIButton* sxiCollapseButton;
%property (assign,nonatomic) BOOL sxiIsLTR;

-(void)viewWillAppear:(bool)whatever {
    %orig;
    [self sxiUpdateCount];
}

-(void)viewDidAppear:(bool)whatever {
    %orig;
    [self sxiUpdateCount];
}

-(void)viewDidLayoutSubviews {
    [self sxiUpdateCount];
    %orig;
}

%new
-(void)sxiCollapse:(UIButton *)button {
    [self.notificationRequest sxiCollapse];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (animationDurationDefault*animationMultiplier) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [listCollectionView reloadData];
    });
}

%new
-(void)sxiClearAll:(UIButton *)button {
    [self.notificationRequest sxiClearStack];
}

%new
-(CGRect)sxiGetClearAllButtonFrame {
    if (self.sxiIsLTR) {
        return CGRectMake(self.view.frame.origin.x + self.view.frame.size.width - (2*buttonSpacing) - (2*buttonWidth) - headerPadding, self.view.frame.origin.y + buttonSpacing, buttonWidth, buttonHeight);
    } else {
        return CGRectMake(self.view.frame.origin.x + buttonSpacing + headerPadding, self.view.frame.origin.y + buttonSpacing, buttonWidth, buttonHeight);
    }
}

%new
-(CGRect)sxiGetCollapseButtonFrame {
    if (self.sxiIsLTR) {
        return CGRectMake(self.view.frame.origin.x + self.view.frame.size.width - buttonSpacing - buttonWidth - headerPadding, self.view.frame.origin.y + buttonSpacing, buttonWidth, buttonHeight);
    } else {
        return CGRectMake(self.view.frame.origin.x + (2*buttonSpacing) + buttonWidth + headerPadding, self.view.frame.origin.y + buttonSpacing, buttonWidth, buttonHeight);
    }
}

%new
-(CGRect)sxiGetNotificationCountFrame {
    return CGRectMake(self.view.frame.origin.x + 11, self.view.frame.origin.y + self.view.frame.size.height - 30, self.view.frame.size.width - 21, moreLabelHeight + 2*buttonSpacing);
}

%new
-(CGRect)sxiGetTitleFrame {
    if (self.sxiIsLTR) {
        return CGRectMake(self.view.frame.origin.x + buttonSpacing + headerPadding, self.view.frame.origin.y + buttonSpacing, self.view.frame.size.width - (buttonSpacing*4) - (buttonWidth*2), buttonHeight - buttonSpacing/2.0);
    } else {
        return CGRectMake(self.view.frame.origin.x + (buttonSpacing*4) + (buttonWidth*2), self.view.frame.origin.y + buttonSpacing, self.view.frame.size.width - (buttonSpacing*5) - (buttonWidth*2) - headerPadding, buttonHeight - buttonSpacing/2.0);
    }
}

%new
-(void)sxiUpdateCount {
    bool inBanner = FALSE;
    if (!self.nextResponder || !self.nextResponder.nextResponder || ![NSStringFromClass([self.nextResponder.nextResponder class]) isEqualToString:@"NCNotificationListCell"]) {
        inBanner = TRUE; //probably, but it's a safe assumption
    }

    if (inBanner && !self.sxiNotificationCount) return;

    self.sxiIsLTR = true;
    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.sxiIsLTR = false;
    }

    NCNotificationShortLookView *lv = (NCNotificationShortLookView *)MSHookIvar<UIView *>(self, "_lookView");

    if (inBanner) {
        self.sxiNotificationCount.hidden = TRUE;
        if (self.sxiClearAllButton) self.sxiClearAllButton.hidden = TRUE;
        if (self.sxiCollapseButton) self.sxiCollapseButton.hidden = TRUE;

        if (lv) {
            lv.customContentView.hidden = TRUE;
            [lv _headerContentView].hidden = TRUE;
            lv.alpha = 1.0;
        }

        return;
    }

    if (!self.sxiNotificationCount) {
        self.sxiNotificationCount = [[UILabel alloc] initWithFrame:[self sxiGetNotificationCountFrame]];
        [self.sxiNotificationCount setFont:[UIFont systemFontOfSize:12]];
        self.sxiNotificationCount.numberOfLines = 1;
        self.sxiNotificationCount.clipsToBounds = YES;
        self.sxiNotificationCount.hidden = YES;
        self.sxiNotificationCount.alpha = 0.0;
        self.sxiNotificationCount.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self.view addSubview:self.sxiNotificationCount];

        if (showButtons > 0) {
            self.sxiClearAllButton = [[SXIButton alloc] initWithFrame:[self sxiGetClearAllButtonFrame]];
            [self.sxiClearAllButton.button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            self.sxiClearAllButton.hidden = YES;
            self.sxiClearAllButton.alpha = 0.0;
            [self.sxiClearAllButton.button setTitle:[translationDict objectForKey:kClear] forState: UIControlStateNormal];
            //self.sxiClearAllButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            [self.sxiClearAllButton.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.sxiClearAllButton.layer.masksToBounds = true;
            self.sxiClearAllButton.layer.cornerRadius = buttonHeight/2.0;
            [self.sxiClearAllButton addBlurEffect];

            self.sxiCollapseButton = [[SXIButton alloc] initWithFrame:[self sxiGetCollapseButtonFrame]];
            [self.sxiCollapseButton.button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            self.sxiCollapseButton.hidden = YES;
            self.sxiCollapseButton.alpha = 0.0;
            [self.sxiCollapseButton.button setTitle:[translationDict objectForKey:kCollapse] forState:UIControlStateNormal];
            //self.sxiCollapseButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            [self.sxiCollapseButton.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.sxiCollapseButton.layer.masksToBounds = true;
            self.sxiCollapseButton.layer.cornerRadius = buttonHeight/2.0;
            [self.sxiCollapseButton addBlurEffect];

            [self.sxiClearAllButton.button addTarget:self action:@selector(sxiClearAll:) forControlEvents:UIControlEventTouchUpInside];
            [self.sxiCollapseButton.button addTarget:self action:@selector(sxiCollapse:) forControlEvents:UIControlEventTouchUpInside];

            if (useIcons) {
                float inset = 2.5;
                if (showButtons == 2) inset = 5.0;
                self.sxiClearAllButton.button.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
                self.sxiCollapseButton.button.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);

                self.sxiCollapseButton.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.sxiCollapseButton.button setTitle:NULL forState:UIControlStateNormal];
                UIImage *btnCollapseImage = [currentTheme getIcon:@"SXICollapse.png"];
                [self.sxiCollapseButton.button setImage:btnCollapseImage forState:UIControlStateNormal];
                self.sxiCollapseButton.tintColor = [UIColor blackColor];

                self.sxiClearAllButton.button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.sxiClearAllButton.button setTitle:NULL forState:UIControlStateNormal];
                UIImage *btnClearAllImage = [currentTheme getIcon:@"SXIClearAll.png"];
                [self.sxiClearAllButton.button setImage:btnClearAllImage forState:UIControlStateNormal];
                self.sxiClearAllButton.tintColor = [UIColor blackColor];
            }

            [self.view addSubview:self.sxiClearAllButton];
            [self.view addSubview:self.sxiCollapseButton];

            if (showButtons == 2) {
                self.sxiTitle = [[UILabel alloc] initWithFrame:[self sxiGetTitleFrame]];
                [self.sxiTitle setFont:[UIFont systemFontOfSize:buttonHeight - buttonSpacing]];
                self.sxiTitle.numberOfLines = 1;
                self.sxiTitle.clipsToBounds = YES;
                self.sxiTitle.hidden = YES;
                self.sxiTitle.alpha = 0.0;
                self.sxiTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                [self.view addSubview:self.sxiTitle];
            }
        }
    }

    if (showButtons > 0) {
        [self.view bringSubviewToFront:self.sxiClearAllButton];
        [self.view bringSubviewToFront:self.sxiCollapseButton];

        if (showButtons == 2) {
            [self.view bringSubviewToFront:self.sxiTitle];
        }
    }

    if (lv && [lv _notificationContentView] && [lv _notificationContentView].primaryLabel && [lv _notificationContentView].primaryLabel.textColor) {
        self.sxiNotificationCount.textColor = [[lv _notificationContentView].primaryLabel.textColor colorWithAlphaComponent:0.8];
        //if (self.sxiTitle) self.sxiTitle.textColor = [[lv _notificationContentView].primaryLabel.textColor colorWithAlphaComponent:0.9];
    }

    if (lv) {
        lv.customContentView.hidden = !self.notificationRequest.sxiVisible;
        [lv _headerContentView].hidden = !self.notificationRequest.sxiVisible;

        if (!self.notificationRequest.sxiVisible) {
            self.view.userInteractionEnabled = false;
            lv.alpha = 0.7;
        } else {
            self.view.userInteractionEnabled = true;
            lv.alpha = 1.0;
        }
    }

    self.sxiNotificationCount.frame = [self sxiGetNotificationCountFrame];
    self.sxiNotificationCount.hidden = YES;
    self.sxiNotificationCount.alpha = 0.0;

    if (showButtons > 0) {
        self.sxiClearAllButton.frame = [self sxiGetClearAllButtonFrame];
        self.sxiCollapseButton.frame = [self sxiGetCollapseButtonFrame];

        self.sxiClearAllButton.hidden = YES;
        self.sxiClearAllButton.alpha = 0.0;

        self.sxiCollapseButton.hidden = YES;
        self.sxiCollapseButton.alpha = 0.0;

        if (showButtons == 2) {
            self.sxiTitle.frame = [self sxiGetTitleFrame];
            self.sxiTitle.hidden = YES;
            self.sxiTitle.alpha = 0.0;
        }
    }

    if ([NSStringFromClass([self.view.superview class]) isEqualToString:@"UIView"] && self.notificationRequest.sxiIsStack && [self.notificationRequest.sxiStackedNotificationRequests count] > 0) {
        if (!self.notificationRequest.sxiIsExpanded) {
            self.sxiNotificationCount.hidden = NO;
            self.sxiNotificationCount.alpha = 1.0;

            int count = [self.notificationRequest.sxiStackedNotificationRequests count];
            if (count == 1) {
                self.sxiNotificationCount.text = [NSString stringWithFormat:[translationDict objectForKey:kOneMoreNotif], [formatter stringFromNumber:@(count)]];
            } else {
                self.sxiNotificationCount.text = [NSString stringWithFormat:[translationDict objectForKey:kMoreNotifs], [formatter stringFromNumber:@(count)]];
            }
        } else if (showButtons > 0) {
            if (showButtons == 1) {
                ((UILabel*)[[lv _headerContentView] _dateLabel]).hidden = YES;
                ((UILabel*)[[lv _headerContentView] _dateLabel]).alpha = 0.0;
            }

            if (showButtons == 2) {
                self.sxiTitle.text = self.notificationRequest.content.header;
                self.sxiTitle.hidden = NO;
                self.sxiTitle.alpha = 1.0;
            }

            self.sxiClearAllButton.hidden = NO;
            self.sxiClearAllButton.alpha = 1.0;

            self.sxiCollapseButton.hidden = NO;
            self.sxiCollapseButton.alpha = 1.0;
        }
    }

    [self.view bringSubviewToFront:self.sxiNotificationCount];
}

- (void)_handleTapOnView:(id)arg1 {
    bool inBanner = FALSE;
    if (!self.nextResponder || !self.nextResponder.nextResponder || ![NSStringFromClass([self.nextResponder.nextResponder class]) isEqualToString:@"NCNotificationListCell"]) {
        inBanner = TRUE; //probably, but it's a safe assumption
    }

    if (clvc.sxiClearAllButton && clvc.sxiClearAllConfirm) {
        clvc.sxiClearAllConfirm = false;
        [clvc sxiUpdateClearAllButton];
    }

    if (!inBanner && self.notificationRequest.sxiIsStack && !self.notificationRequest.sxiIsExpanded && [self.notificationRequest.sxiStackedNotificationRequests count] > 0) {
        [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.sxiNotificationCount.alpha = 0;
        } completion:NULL];
        [self.notificationRequest sxiExpand];
        return;
    }

    if (!inBanner && !self.notificationRequest.sxiVisible) {
        return; // don't allow taps on stacked notifications
    }

    return %orig;
}

%end

%hook NCNotificationListCollectionView

-(id)initWithFrame:(CGRect)arg1 collectionViewLayout:(id)arg2 {
    id orig = %orig;
    listCollectionView = self;
    return orig;
}

-(void)reloadData {
    if (!canUpdate) return;
    %orig;
    [priorityList sxiUpdateList];
    [self.collectionViewLayout invalidateLayout];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    for (NSInteger row = 0; row < [self numberOfItemsInSection:0]; row++) {
        id c = [self _visibleCellForIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (!c) continue;

        NCNotificationListCell* cell = (NCNotificationListCell*)c;
        NCNotificationShortLookViewController *cvc = (NCNotificationShortLookViewController *)cell.contentViewController;
        [self sendSubviewToBack:cell];
        if (remakeButtons) {
            [cvc.sxiClearAllButton removeFromSuperview];
            [cvc.sxiCollapseButton removeFromSuperview];
            [cvc.sxiTitle removeFromSuperview];
            [cvc.sxiNotificationCount removeFromSuperview];

            cvc.sxiClearAllButton = nil;
            cvc.sxiCollapseButton = nil;
            cvc.sxiTitle = nil;
            cvc.sxiNotificationCount = nil;
        }
        [cvc sxiUpdateCount];
    }

    //LPP compatibility
    if ([self numberOfItemsInSection:0] > 0) {
        [sbdbclvc _setListHasContent:YES];
    } else {
        [sbdbclvc _setListHasContent:NO];
    }
}

%new
-(void)sxiClearAll {
    for (NSInteger row = 0; row < [self numberOfItemsInSection:0]; row++) {
        id c = [self _visibleCellForIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (!c) continue;
        NCNotificationListCell* cell = (NCNotificationListCell*)c;
        [UIView animateWithDuration:(animationDurationClear*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.alpha = 0.0;
        } completion:NULL];
    }
}

%new
-(void)sxiClear:(NSString *)notificationIdentifier {
    for (NSInteger row = 0; row < [self numberOfItemsInSection:0]; row++) {
        id c = [self _visibleCellForIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (!c) continue;
        NCNotificationListCell* cell = (NCNotificationListCell*)c;
        if ([notificationIdentifier isEqualToString:cell.contentViewController.notificationRequest.notificationIdentifier]) {

            [UIView animateWithDuration:(animationDurationClear*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.alpha = 0.0;
            } completion:NULL];
        }
    }
}

%new
-(void)sxiCollapseAll {
    NSMutableOrderedSet *sectionIDs = [NSMutableOrderedSet new];

    for (NCNotificationRequest *request in priorityList.requests) {
        if (!request.bulletin.sectionID) continue;

        NSString *stackID = [request sxiStackID];
        if (![sectionIDs containsObject:stackID] && request.sxiIsStack && request.sxiIsExpanded) {
            [request sxiCollapse];
            [sectionIDs addObject:stackID];
        }
    }

    [listCollectionView reloadData];
}

%new
-(void)sxiExpand:(NSString *)sectionID {
    NSMutableOrderedSet *sectionIDs = [NSMutableOrderedSet new];
    [sectionIDs addObject:sectionID];

    // DON'T REPLACE THIS WITH sxiCollapseAll; it doesn't work because of that line above
    for (NCNotificationRequest *request in priorityList.requests) {
        if (!request.bulletin.sectionID) continue;

        NSString *stackID = [request sxiStackID];
        if (![sectionIDs containsObject:stackID] && request.sxiIsStack && request.sxiIsExpanded) {
            [request sxiCollapse];
            [sectionIDs addObject:stackID];
        }
    }

    [listCollectionView reloadData];

    CGRect frame = CGRectMake(0,0,0,0);
    bool frameFound = false;
    int offset = buttonHeight + buttonSpacing*3;
    for (NSInteger row = 0; row < [self numberOfItemsInSection:0]; row++) {
        id c = [self _visibleCellForIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (!c) continue;

        NCNotificationListCell* cell = (NCNotificationListCell*)c;
        if ([sectionID isEqualToString:[cell.contentViewController.notificationRequest sxiStackID]]) {
            if (!frameFound) {
                frameFound = true;
                frame = cell.frame;

                if (showButtons == 2) {
                    frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + offset, cell.frame.size.width, cell.frame.size.height);
                    NCNotificationShortLookViewController *controller = (NCNotificationShortLookViewController *)cell.contentViewController;

                    if (controller.notificationRequest.sxiIsStack && controller.notificationRequest.sxiIsExpanded && !cell.sxiReturnSVToOrigFrame) {
                        CGRect svFrame = controller.scrollView.frame;
                        cell.sxiReturnSVToOrigFrame = true;
                        cell.sxiSVOrigFrame = svFrame;

                        [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            controller.scrollView.frame = CGRectMake(svFrame.origin.x, svFrame.origin.y + offset, svFrame.size.width, svFrame.size.height - offset);
                        } completion:NULL];
                    }
                }

                continue;
            }

            //[self sendSubviewToBack:cell];

            CGRect properFrame = cell.frame;
            cell.frame = frame;
            [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.frame = properFrame;
            } completion:NULL];
        }
    }
}

%new
-(void)sxiCollapse:(NSString *)sectionID {
    CGRect frame = CGRectMake(0,0,0,0);
    bool frameFound = false;
    int offset = buttonHeight + buttonSpacing*3;
    int height = 0;
    for (NSInteger row = 0; row < [self numberOfItemsInSection:0]; row++) {
        id c = [self _visibleCellForIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        if (!c) continue;

        NCNotificationListCell* cell = (NCNotificationListCell*)c;
        if ([sectionID isEqualToString:[cell.contentViewController.notificationRequest sxiStackID]]) {
            if (!frameFound) {
                frameFound = true;
                frame = cell.frame;

                NCNotificationListCell* nextCell = (NCNotificationListCell *)[self _visibleCellForIndexPath:[NSIndexPath indexPathForRow:row+1 inSection:0]];
                height = nextCell.frame.size.height;

                if (showButtons == 2) {
                    NCNotificationShortLookViewController *controller = (NCNotificationShortLookViewController *)cell.contentViewController;

                    if (controller.notificationRequest.sxiIsStack && !controller.notificationRequest.sxiIsExpanded && cell.sxiReturnSVToOrigFrame) {
                        CGRect svFrame = controller.scrollView.frame;
                        cell.sxiReturnSVToOrigFrame = false;

                        CGRect ncFrame = controller.sxiNotificationCount.frame;
                        controller.sxiNotificationCount.frame = CGRectMake(ncFrame.origin.x, ncFrame.origin.y + offset, ncFrame.size.width, ncFrame.size.height);

                        [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            controller.scrollView.frame = CGRectMake(svFrame.origin.x, svFrame.origin.y - offset, svFrame.size.width, svFrame.size.height + offset);
                            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height - offset + moreLabelHeight);
                            controller.sxiNotificationCount.frame = ncFrame;
                        } completion:NULL];
                    }
                }

                continue;
            }

            if (cell.contentViewController.notificationRequest.sxiPositionInStack > MAX_SHOW_BEHIND) {
                [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.alpha = 0.0;
                } completion:NULL];
            } else {
                cell.frame = CGRectMake((20 * cell.contentViewController.notificationRequest.sxiPositionInStack)/2, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                [UIView animateWithDuration:(animationDurationDefault*animationMultiplier) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.frame = CGRectMake(
                        frame.origin.x + (10 * cell.contentViewController.notificationRequest.sxiPositionInStack),
                        frame.origin.y + height - 50 + moreLabelHeight + (10 * cell.contentViewController.notificationRequest.sxiPositionInStack),
                        frame.size.width - (20 * cell.contentViewController.notificationRequest.sxiPositionInStack),
                        50)
                    ;
                } completion:NULL];
            }
        }
    }
}

-(void)deleteItemsAtIndexPaths:(id)arg1 { [self reloadData]; }
-(void)insertItemsAtIndexPaths:(id)arg1 { [self reloadData]; }
-(void)reloadItemsAtIndexPaths:(id)arg1 { [self reloadData]; }
-(void)reloadSections:(id)arg1 { [self reloadData]; }
-(void)deleteSections:(id)arg1 { [self reloadData]; }
-(void)insertSections:(id)arg1 { [self reloadData]; }
-(void)moveItemAtIndexPath:(id)prevPath toIndexPath:(id)newPath { [self reloadData]; }

-(void)performBatchUpdates:(id)updates completion:(void (^)(bool finished))completion {
	[self reloadData];
	if (completion) completion(true);
}

%end

%hook NCNotificationListCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSArray *attrs =  %orig;

    for (UICollectionViewLayoutAttributes *attr in attrs) {
        if (attr.size.height == 0) {
            attr.hidden = YES;
        } else {
            attr.hidden = NO;
        }
    }

    return attrs;
}

%end

%hook SBDashBoardViewController

-(id)init {
    id orig = %orig;
    sbdbvc = self;
    return orig;
}

-(void)viewWillAppear:(BOOL)animated {
    %orig;

    isOnLockscreen = !self.authenticated;
    [listCollectionView sxiCollapseAll];
}

%end

%end

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    isOnLockscreen = true;
    [listCollectionView sxiCollapseAll];
    clvc.sxiClearAllConfirm = false;
    [clvc sxiUpdateClearAllButton];
}

void reloadPreferences() {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"io.ominousness.stackxi"];
    enabled = [([file objectForKey:@"Enabled"] ?: @(YES)) boolValue];
    showButtons = [([file objectForKey:@"ShowButtons"] ?: @(2)) intValue];
    groupBy = [([file objectForKey:@"GroupBy"] ?: @(0)) intValue];
    useIcons = [([file objectForKey:@"UseIcons"] ?: @(YES)) boolValue];
    showClearAllButton = [([file objectForKey:@"ShowClearAll"] ?: @(YES)) boolValue];
    forceOldBehavior = [([file objectForKey:@"ForceOldBehavior"] ?: @(NO)) boolValue];
    buttonIconStyle = [([file objectForKey:@"ButtonIconStyle"] ?: @(0)) intValue];

    NSString *iconTheme = [file objectForKey:@"IconTheme"];
    if(!iconTheme){
        iconTheme = @"Default";
    }

    currentTheme = [SXITheme themeWithPath:[SXIThemesDirectory stringByAppendingPathComponent:iconTheme]];

    int speed = [([file objectForKey:@"AnimationSpeed"] ?: @(5)) intValue];
    animationMultiplier = (10.0-speed)*2.0/10.0;

    if (useIcons) {
        buttonWidth = 45;
    } else {
        buttonWidth = 75;
    }

    if (showButtons == 2) {
        buttonHeight = 30;
        headerPadding = 5;
    } else {
        buttonHeight = 25;
        headerPadding = 0;
    }

    if (clvc) {
        clvc.sxiClearAllConfirm = false;
        [clvc.sxiClearAllButton removeFromSuperview];
        clvc.sxiClearAllButton = nil;
        [clvc sxiMakeClearAllButton];
        [clvc sxiUpdateClearAllButton];
    }

    if (listCollectionView) {
        remakeButtons = true;
        [listCollectionView reloadData];
        remakeButtons = false;
    }
}

%ctor{
    reloadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, (CFStringRef)SXINotification, NULL, kNilOptions);
    bool debug = false;
    #ifdef DEBUG
    debug = true;
    #endif

    formatter.numberStyle = NSNumberFormatterNoStyle;

    if (enabled) {
        NSBundle *langBundle = [NSBundle bundleWithPath:LANG_BUNDLE_PATH];
        translationDict = @{
            kClear : langBundle ? [langBundle localizedStringForKey:kClear value:@"Clear All" table:nil] : @"Clear All",
            kCollapse : langBundle ? [langBundle localizedStringForKey:kCollapse value:@"Collapse" table:nil] : @"Collapse",
            kOneMoreNotif : langBundle ? [langBundle localizedStringForKey:kOneMoreNotif value:@"%@ more notification" table:nil] : @"%@ more notification",
            kMoreNotifs : langBundle ? [langBundle localizedStringForKey:kMoreNotifs value:@"%@ more notifications" table:nil] : @"%@ more notifications"
        };
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
        %init(StackXI);
        if (debug) %init(StackXIDebug);
    }
}
