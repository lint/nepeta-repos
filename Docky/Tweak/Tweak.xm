#import "Tweak.h"

HBPreferences *preferences;

int columns = 4;
bool ipx = false;
CGFloat heightMultiplier = 1.75;

bool dpkgInvalid = NO;
bool enabled = YES;
bool fiveIcons = NO;
bool infinitePaging = NO;
bool infiniteScrollbar = YES;
bool infiniteSnap = YES;
CGFloat infiniteSpacing = 10;
NSInteger dockMode = 0; // 0 - regular, 1 - double, 2 - expandable, 3 - infinite
NSInteger forceStyle = 0; // 0 - no, 1 - ipx, 2 - ipold
CGFloat backgroundAlpha = 1.0;

SBDockView *dockView = nil;
UIScrollView *dockScrollView = nil;
CGSize iconSize = CGSizeZero;

@implementation DCKScrollViewDelegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat iconWidth = (iconSize.width > 0) ? iconSize.width + infiniteSpacing : 10;
    NSInteger index = floor((targetContentOffset->x - infiniteSpacing) / iconWidth);

    if (((targetContentOffset->x - infiniteSpacing) - (floor(targetContentOffset->x / iconWidth) * iconWidth)) > iconWidth/2) {
        index++;
    }

    targetContentOffset->x = index * iconWidth + infiniteSpacing;
}

@end

%group Docky

%hook SBDockView

%property (nonatomic, retain) UIPanGestureRecognizer *dckGestureRecognizer;
%property (nonatomic, retain) UIScrollView *dckScrollView;
%property (nonatomic, retain) DCKScrollViewDelegate *dckScrollViewDelegate;

-(id)initWithDockListView:(UIView *)dockListView forSnapshot:(BOOL)arg2 {
    %orig;
    
    if (dockMode == 2) {
        self.dckGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dckGesture:)];
        self.dckGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self addGestureRecognizer:self.dckGestureRecognizer];
    }

    else if (dockMode == 3) {
        UIView *backgroundView = [self valueForKey:@"_backgroundView"];
        self.dckScrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
        [self addSubview:self.dckScrollView];
        [dockListView removeFromSuperview];
        [self.dckScrollView addSubview:dockListView];
        dockScrollView = self.dckScrollView;

        if (infiniteSnap && !infinitePaging) {
            self.dckScrollViewDelegate = [DCKScrollViewDelegate alloc];
            self.dckScrollView.delegate = self.dckScrollViewDelegate;
        }

        self.dckScrollView.pagingEnabled = infinitePaging;
        self.dckScrollView.showsHorizontalScrollIndicator = infiniteScrollbar;
        self.dckScrollView.showsVerticalScrollIndicator = infiniteScrollbar;
        self.dckScrollView.layer.masksToBounds = YES;
        self.dckScrollView.translatesAutoresizingMaskIntoConstraints = NO;

        UIView *anchorView = self;
        if (ipx) anchorView = backgroundView;

        [NSLayoutConstraint activateConstraints:@[
            [self.dckScrollView.topAnchor constraintEqualToAnchor:anchorView.topAnchor constant:0],
            [self.dckScrollView.bottomAnchor constraintEqualToAnchor:anchorView.bottomAnchor constant:0],
            [self.dckScrollView.leadingAnchor constraintEqualToAnchor:anchorView.leadingAnchor constant:0],
            [self.dckScrollView.trailingAnchor constraintEqualToAnchor:anchorView.trailingAnchor constant:0],
        ]];
    }

    dockView = self;

    return self;
}

-(void)_updateCornerRadii {
    %orig;

    if (dockMode == 3) {
        UIView *backgroundView = [self valueForKey:@"_backgroundView"];
        self.dckScrollView.layer.continuousCorners = backgroundView.layer.continuousCorners;
        self.dckScrollView.layer.cornerRadius = backgroundView.layer.cornerRadius;
        return;
    }
}

-(void)setBackgroundAlpha:(double)alpha {
    %orig(alpha * backgroundAlpha);
}

-(double)dockHeight {
    if (dockMode == 1) return %orig * heightMultiplier;
    return %orig;
}

-(CGRect)dockListViewFrame {
    if (dockMode == 3) return CGRectMake(0, [self dockHeightPadding], 10000, [self dockHeight]);
    return %orig;
}

-(void)layoutSubviews {
    %orig;

    if (dockMode == 0 || dockMode == 3) return;
    if (self.frame.size.height < 10) return;
    
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    CGRect oldFrame = backgroundView.frame;
    backgroundView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, self.frame.size.height - oldFrame.origin.x);

    UIView *iconListView = [self valueForKey:@"_iconListView"];
    iconListView.clipsToBounds = YES;
    CGRect otherFrame = iconListView.frame;
    iconListView.frame = CGRectMake(0, 0, otherFrame.size.width, self.frame.size.height - oldFrame.origin.x);
}

%new
-(void)dckGesture:(UIPanGestureRecognizer *)recognizer {
    if (dockMode != 2) return;

    CGPoint translation = [recognizer translationInView:self];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        bool visible = YES;

        CGFloat height = [self dockHeight];
        if (self.frame.origin.y > height) {
            visible = NO;
        }

        CGPoint velocity = [recognizer velocityInView:self];
        if (velocity.y > 5) {
            visible = NO;
        } else if (velocity.y < -5) {
            visible = YES;
        }

        [self dckVisible:visible];
    } else {
        [self dckHeight:self.frame.size.height - translation.y];
    }

    [recognizer setTranslation:CGPointZero inView:self];
}

%new
-(void)dckHeight:(CGFloat)height {
    [self.superview bringSubviewToFront:self];
    
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    CGRect oldFrame = backgroundView.frame;

    UIView *iconListView = [self valueForKey:@"_iconListView"];
    CGRect otherFrame = iconListView.frame;

    backgroundView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height - oldFrame.origin.x);
    iconListView.frame = CGRectMake(otherFrame.origin.x, 0, otherFrame.size.width, height - oldFrame.origin.x);
    self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height - height, self.frame.size.width, height);
}

%new
-(void)dckVisible:(BOOL)visible {
    if (dockMode != 2) return;

    CGFloat height = [self dockHeight];
    if (visible) {
        height *= heightMultiplier;
    }
    
    [UIView animateWithDuration:0.4
            delay:0.0
            usingSpringWithDamping:0.55
            initialSpringVelocity:0.1
            options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self dckHeight:height];
    } completion:NULL];
}

%end

%hook SBIconController

-(unsigned long long)maxIconCountForDock {
    return [%c(SBRootFolderDockIconListView) maxIcons];
}

%end

%hook UITraitCollection

-(CGFloat)displayCornerRadius {
    CGFloat ret = %orig;
    if (forceStyle > 0) {
        ret = (forceStyle == 1) ? 6 : 0;
    }

    ipx = ret > 0;
    
    return ret;
}

%end

%hook SBRootFolderDockIconListView

-(void)updateEditingStateAnimated:(BOOL)animated {
    %orig;
    
    if (dockMode == 2 && [self isEditing]) {
        [dockView dckVisible:YES];
    }
}

+(unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1 {
    if (arg1 > 1) return (dockMode == 1 || dockMode == 2) ? 2 : 1;

    if (dockMode == 3) return 100;
    return (fiveIcons) ? 5 : 4;
}

-(void)setMinimumNumberOfIconsToDistributeEvenlyToEdges:(unsigned long long)arg1 {
    %orig(0);
}

+(unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1 {
    if (arg1 > 1) {
        if (dockMode == 3) return 100;
        return (fiveIcons) ? 5 : 4;
    }

    return (dockMode == 1 || dockMode == 2) ? 2 : 1;
}

-(void)setFrame:(CGRect)frame {
    if (dockMode != 3) {
        %orig;
        return;
    }

    %orig(CGRectMake(0, frame.origin.y, 10000, frame.size.height));
}

+(unsigned long long)maxVisibleIconRowsInterfaceOrientation:(long long)arg1 {
    return [%c(SBRootFolderDockIconListView) iconRowsForInterfaceOrientation:arg1];
}

+(unsigned long long)maxIcons {
    if (dockMode == 3) return 100;
    return 1 + ((fiveIcons) ? 5 : 4) * ((dockMode == 0) ? 1 : 2);
}

-(BOOL)allowsAddingIconCount:(unsigned long long)arg1 {
    if (dockMode == 3) return YES;
    if (dockMode != 0) {
        int count = [[self icons] count];
        return ((arg1 + count) <= [%c(SBRootFolderDockIconListView) maxIcons]);
    }

    return %orig;
}

+(unsigned long long)maxVisibleIcons {
    return [%c(SBRootFolderDockIconListView) maxIcons];
}

-(double)_additionalHorizontalInsetToCenterIcons {
    return 0;
}

-(double)_additionalVerticalInsetToCenterIcons {
    return 0;
}

-(unsigned long long)columnAtPoint:(CGPoint)arg1 {
    if (dockMode != 3) return %orig;
    CGSize size = [self defaultIconSize];

    if (infinitePaging) {
        int page = ceil(arg1.x/dockScrollView.frame.size.width);
        int max = (fiveIcons) ? 5 : 4;
        CGFloat offset = (dockScrollView.frame.size.width - max * (size.width + infiniteSpacing))/2;
        CGFloat x = offset * ((page - 1)*2 + 1);

        return (arg1.x - x - infiniteSpacing/2)/(size.width + infiniteSpacing);
    } else {
        return (arg1.x - infiniteSpacing)/(size.width + infiniteSpacing);
    }
}

-(unsigned long long)rowAtPoint:(CGPoint)arg1 {
    if (dockMode == 0) return %orig;
    if (dockMode == 3) return 0;

    CGFloat div = arg1.y/[%c(SBRootFolderDockIconListView) defaultHeight];
    return (div > 1) ? 1 : 0;
}

-(CGRect)boundsForLayout {
    if (dockMode != 3) return %orig;

    CGFloat height = 92; //todo find a proper value

    int count = [[self icons] count];
    CGSize size = [self defaultIconSize];
    CGFloat width = count * (size.width + infiniteSpacing) + infiniteSpacing*2;

    if (infinitePaging) {
        int max = (fiveIcons) ? 5 : 4;
        width = dockScrollView.frame.size.width * (ceil(count/max) + 1);
    }

    CGRect newFrame = CGRectMake(0, 0, width, height);
    dockScrollView.contentSize = CGSizeMake(width, height);

    return newFrame;
}

-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 {
    if (dockMode == 0 && !fiveIcons) return %orig;

    CGSize size = [self defaultIconSize];
    iconSize = size;

    if (dockMode == 3) {
        CGPoint orig = %orig;
        CGFloat x = infiniteSpacing;
        
        if (infinitePaging) {
            int max = (fiveIcons) ? 5 : 4;
            CGFloat offset = (dockScrollView.frame.size.width - max * (size.width + infiniteSpacing))/2;
            x = offset * (ceil((arg1.col - 1)/max)*2 + 1);
        }

        return CGPointMake(((size.width + infiniteSpacing) * (arg1.col - 1)) + x + infiniteSpacing/2, orig.y);
    }
    
    CGFloat top = [%c(SBRootFolderDockIconListView) defaultHeight] - size.height;

    CGFloat x = (size.width + [self horizontalIconPadding]) * (arg1.col - 1) + [self sideIconInset];
    CGFloat y = (size.height + [dockView dockHeightPadding]/2) * (arg1.row - 1) + top;

    if (ipx) {
        top = [%c(SBRootFolderDockIconListView) defaultHeight] - [dockView dockHeightPadding] - size.height;
        y = (size.height + [dockView dockHeightPadding] + 2) * (arg1.row - 1) + top;
    }
    
    return CGPointMake(x, y);
}

%end

%end

%group DockyIntegrityFail

%hook SBIconController

%property (retain,nonatomic) WKWebView *dckIntegrityView;

-(void)loadView{
    %orig;
    if (!dpkgInvalid) return;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.dckIntegrityView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://piracy.nepeta.me/"]];
    [self.dckIntegrityView loadRequest:request];
    [self.view addSubview:self.dckIntegrityView];
    [self.view sendSubviewToBack:self.dckIntegrityView];
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    if (!dpkgInvalid) return;
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of Docky you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Docky is free. Uninstall this build and install the proper version of Docky from:\nhttps://repo.nepeta.me/\n(it's free, damnit, why would you pirate that!?)\n\nIf you're seeing this message but have obtained Docky from an official source, add https://repo.nepeta.me/ to Cydia, Sileo or Zebra and respring."
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Damn!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:@"https://repo.nepeta.me/"] options:@{} completionHandler:nil];

        [self dismissViewControllerAnimated:YES completion:NULL];
    }]];

    [self presentViewController:alertController animated:YES completion:NULL];
}

%end

%end

%ctor{
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.docky.list"];
    if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.docky.md5sums"];
    
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.docky"];
    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerBool:&fiveIcons default:NO forKey:@"FiveIcons"];
    [preferences registerInteger:&dockMode default:0 forKey:@"DockMode"];
    [preferences registerInteger:&forceStyle default:0 forKey:@"ForceStyle"];
    [preferences registerDouble:&backgroundAlpha default:1 forKey:@"BackgroundAlpha"];
    [preferences registerBool:&infinitePaging default:NO forKey:@"InfinitePaging"];
    [preferences registerBool:&infiniteScrollbar default:YES forKey:@"InfiniteScrollbar"];
    [preferences registerBool:&infiniteSnap default:YES forKey:@"InfiniteSnap"];
    [preferences registerDouble:&infiniteSpacing default:10 forKey:@"InfiniteSpacing"];

    if (!dpkgInvalid && enabled) {
        BOOL ok = false;
        
        ok = ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@%@%@%@%@%@%@%@%@.docky.md5sums", @"m", @"e", @".", @"n", @"e", @"p", @"e", @"t", @"a"]]);

        if (ok && [@"nepeta" isEqualToString:@"nepeta"]) {
            %init(Docky);
            return;
        } else {
            dpkgInvalid = YES;
        }
    }

    if (enabled) %init(DockyIntegrityFail);
}
