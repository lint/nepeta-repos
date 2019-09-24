#import "Tweak.h"

static bool enabled = true;
static bool enabledBanners = true;

%group ModernXI

%hook MTPlatterHeaderContentView

%property (nonatomic, assign) BOOL mxiIsActive;

-(void)_updateStylingForTitleLabel:(id)arg1 {
    %orig;
    if (self.mxiIsActive) {
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }
}

-(void)_layoutTitleLabelWithScale:(double)arg1 {
    %orig;
    if (self.mxiIsActive) {
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + 5, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width - 5, self.titleLabel.frame.size.height);
    }
}
%end

@interface UIImage (UIApplicationIconPrivate)
+ (id)_iconForResourceProxy:(id)arg1 format:(int)arg2;
+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 roleIdentifier:(id)arg2 format:(int)arg3 scale:(float)arg4;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 roleIdentifier:(id)arg2 format:(int)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
+ (int)_iconVariantForUIApplicationIconFormat:(int)arg1 scale:(float *)arg2;
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2 scale:(float)arg3;
- (id)_applicationIconImageForFormat:(int)arg1 precomposed:(BOOL)arg2;
@end

%hook NCNotificationShortLookView

-(void)layoutSubviews{
    %orig;
    if (!enabled) return;

    UIViewController *controller = nil;
    if (self.nextResponder.nextResponder.nextResponder) {
        controller = (UIViewController*)self.nextResponder.nextResponder.nextResponder;
    }
        
        
    if (!enabledBanners) {
        bool inBanner = FALSE;
        if (!controller) {
            return;
        }
        
        if (!controller.nextResponder || !controller.nextResponder.nextResponder || ![NSStringFromClass([controller.nextResponder.nextResponder class]) isEqualToString:@"NCNotificationListCell"]) {
            inBanner = TRUE; //probably, but it's a safe assumption
        }

        if (!enabledBanners && inBanner) return;
    }

    for (UIView *subview in self.subviews) {
		if([subview isKindOfClass:%c(UIImageView)]) {
			subview.hidden = YES;
		}
        if ([NSStringFromClass([subview class]) isEqualToString:@"MTMaterialView"]) {
            [self moveUpBy:-27 view:subview];
        }
    }

    MTPlatterHeaderContentView *headerContentView = [self _headerContentView];
    headerContentView.mxiIsActive = true;

    UIButton *iconButton = (UIButton *)[headerContentView iconButton];
    iconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    iconButton.contentVerticalAlignment   = UIControlContentVerticalAlignmentFill;
    iconButton.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5);

    iconButton.layer.shadowRadius = 3.0f;
    iconButton.layer.shadowColor = [UIColor blackColor].CGColor;
    iconButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    iconButton.layer.shadowOpacity = 0.5f;
    iconButton.layer.masksToBounds = NO;

    if (controller && ((NCNotificationShortLookViewController *)controller).notificationRequest) {
        NCNotificationRequest *req = ((NCNotificationShortLookViewController *)controller).notificationRequest;
        if (req.bulletin && req.bulletin.sectionID) {
            UIImage *icon = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:req.bulletin.sectionID];
            if (icon) {
                [iconButton setImage:icon forState:UIControlStateNormal];
            }
        }
    }

    [headerContentView.titleLabel setTextColor:[UIColor whiteColor]];
    headerContentView.titleLabel.frame = CGRectMake(headerContentView.titleLabel.frame.origin.x + 5, headerContentView.titleLabel.frame.origin.y, headerContentView.titleLabel.frame.size.width - 5, headerContentView.titleLabel.frame.size.height);

    [headerContentView setNeedsLayout];
    [headerContentView layoutIfNeeded];

    [self moveUpBy:5 view:headerContentView];
    if (headerContentView.bounds.origin.x - headerContentView.frame.origin.x == 0) {
        headerContentView.bounds = CGRectInset(headerContentView.bounds, -5.0f, 0);
    }

    MTMaterialView *overlayView = [self valueForKey:@"_mainOverlayView"];
    overlayView.alpha = 0;
    overlayView.hidden = YES;
}

%new
-(void)moveUpBy:(int)y view:(UIView *)view {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - y, view.frame.size.width, view.frame.size.height + y);
}

%end

%end

%ctor{
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:@"io.ominousness.modernxi"];
    enabled = [([file objectForKey:@"Enabled"] ?: @(YES)) boolValue];
    enabledBanners = [([file objectForKey:@"EnabledBanners"] ?: @(YES)) boolValue];

    if (enabled) {
        %init(ModernXI);
    }
}
