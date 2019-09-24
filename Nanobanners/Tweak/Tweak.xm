#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>
#import <Nepeta/NEPColorUtils.h>
#import <AudioToolbox/AudioToolbox.h>
#import <libcolorpicker.h>
#import "Tweak.h"

static BBServer *bbServer = nil;

HBPreferences *preferences;

BOOL dpkgInvalid = false;

bool enabled;
CGFloat marqueeScrollRate;
CGFloat marqueeDelay;

static void fakeNotification(NSString *sectionID, NSDate *date, NSString *message) {
    BBBulletin *bulletin = [[%c(BBBulletin) alloc] init];

    bulletin.title = @"Nanobanners";
    bulletin.message = message;
    bulletin.sectionID = sectionID;
    bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.date = date;
    bulletin.defaultAction = [%c(BBAction) actionWithLaunchBundleID:sectionID callblock:nil];

    SBLockScreenNotificationListController *listController=([[%c(UIApplication) sharedApplication] respondsToSelector:@selector(notificationDispatcher)] && [[[%c(UIApplication) sharedApplication] notificationDispatcher] respondsToSelector:@selector(notificationSource)]) ? [[[%c(UIApplication) sharedApplication] notificationDispatcher] notificationSource]  : [[[%c(SBLockScreenManager) sharedInstanceIfExists] lockScreenViewController] valueForKey:@"notificationController"];
    [listController observer:[listController valueForKey:@"observer"] addBulletin:bulletin forFeed:14];
}

void fakeBanner() {
    fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Test banner! Test banner! Test banner! Test banner! Test banner! Test banner! Test banner! Test banner!");
}

%group Nanobanners

%hook NCNotificationShortLookView

%property (nonatomic, retain) UIView *nanoView;
%property (nonatomic, retain) MPUMarqueeView *nanoMarqueeView;
%property (nonatomic, retain) UIStackView *nanoStackView;
%property (nonatomic, retain) UIImageView *nanoIconView;
%property (nonatomic, retain) UILabel *nanoAppLabel;
%property (nonatomic, retain) UILabel *nanoTitleLabel;
%property (nonatomic, retain) UILabel *nanoTextLabel;

-(void)layoutSubviews{
    %orig;
    
    if (!enabled) {
        if (self.nanoView) [self.nanoView removeFromSuperview];
        return;
    }

    if (![[self _viewControllerForAncestor] respondsToSelector:@selector(delegate)]) return;
    if (![[[self _viewControllerForAncestor] delegate] isKindOfClass:%c(SBNotificationBannerDestination)]) return;

    UIViewController *controller = nil;
    NCNotificationRequest *req = nil;
    if (self.nextResponder.nextResponder.nextResponder) {
        controller = (UIViewController*)self.nextResponder.nextResponder.nextResponder;
        if ([controller isKindOfClass:%c(NCNotificationShortLookViewController)] && ((NCNotificationShortLookViewController *)controller).notificationRequest) {
            req = ((NCNotificationShortLookViewController *)controller).notificationRequest;
        }
    }

    if (!req || !req.content) return;
    NCNotificationContent *content = [req content];

    BOOL isLTR = YES;
    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
        isLTR = NO;
    }

    for (UIView *view in [self subviews]) {
        if (view == self.nanoView) continue;
        [view removeFromSuperview];
    }

    if (!self.nanoView) {
        self.nanoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 34)];
        self.nanoView.backgroundColor = [UIColor colorWithWhite:0.10 alpha:1];
        self.nanoView.layer.cornerRadius = 2.5;
        self.nanoView.layer.masksToBounds = YES;
        [self addSubview:self.nanoView];

        self.nanoView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.nanoView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0],
            [self.nanoView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0],
            [self.nanoView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0],
            [self.nanoView.heightAnchor constraintEqualToConstant:34]
        ]];
    }

    if (!self.nanoMarqueeView) {
        self.nanoMarqueeView = [[%c(MPUMarqueeView) alloc] initWithFrame:self.nanoView.bounds];
        [self.nanoView addSubview:self.nanoMarqueeView];

        self.nanoMarqueeView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.nanoMarqueeView.topAnchor constraintEqualToAnchor:self.nanoView.topAnchor],
            [self.nanoMarqueeView.leadingAnchor constraintEqualToAnchor:self.nanoView.leadingAnchor],
            [self.nanoMarqueeView.trailingAnchor constraintEqualToAnchor:self.nanoView.trailingAnchor],
            [self.nanoMarqueeView.bottomAnchor constraintEqualToAnchor:self.nanoView.bottomAnchor]
        ]];
    }

    self.nanoMarqueeView.marqueeDelay = marqueeDelay;
    self.nanoMarqueeView.marqueeScrollRate = marqueeScrollRate;

    if (!self.nanoStackView) {
        self.nanoStackView = [[UIStackView alloc] initWithFrame:self.nanoMarqueeView.bounds];
        self.nanoStackView.axis = UILayoutConstraintAxisHorizontal;
        self.nanoStackView.spacing = 5.0;
        self.nanoStackView.layoutMarginsRelativeArrangement = YES;
        self.nanoStackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
        [self.nanoMarqueeView.contentView addSubview:self.nanoStackView];

        [NSLayoutConstraint activateConstraints:@[
            [self.nanoStackView.topAnchor constraintEqualToAnchor:self.nanoMarqueeView.contentView.topAnchor],
            [self.nanoStackView.bottomAnchor constraintEqualToAnchor:self.nanoMarqueeView.contentView.bottomAnchor]
        ]];
    }

    MTPlatterHeaderContentView *headerContentView = MSHookIvar<MTPlatterHeaderContentView *>(self, "_headerContentView");
    if (!self.nanoIconView && headerContentView) {
        UIImage *icon = nil;
        if ([headerContentView respondsToSelector:@selector(icon)]) {
            icon = [(UIImage *)[headerContentView icon] copy];
        } else if ([headerContentView respondsToSelector:@selector(icons)]) {
            icon = [(UIImage *)[headerContentView icons][0] copy];
        }

        if (icon) {
            self.nanoIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            self.nanoIconView.image = icon;
            self.nanoIconView.contentMode = UIViewContentModeScaleAspectFit;

            [NSLayoutConstraint activateConstraints:@[
                [self.nanoIconView.heightAnchor constraintEqualToConstant:24],
                [self.nanoIconView.widthAnchor constraintEqualToConstant:24]
            ]];
            [self.nanoStackView addArrangedSubview:self.nanoIconView];
        }
    }

    if (!self.nanoAppLabel && content.header) {
        self.nanoAppLabel = [[UILabel alloc] initWithFrame:self.nanoMarqueeView.bounds];
        self.nanoAppLabel.text = content.header;
        self.nanoAppLabel.font = [UIFont boldSystemFontOfSize:14];
        self.nanoAppLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.nanoAppLabel.textColor = [UIColor whiteColor];
        [self.nanoAppLabel sizeToFit];
        [self.nanoStackView addArrangedSubview:self.nanoAppLabel];
    }

    if (!self.nanoTitleLabel && content.title) {
        self.nanoTitleLabel = [[UILabel alloc] initWithFrame:self.nanoMarqueeView.bounds];
        self.nanoTitleLabel.text = [NSString stringWithFormat:@"%@:", content.title];
        self.nanoTitleLabel.font = [UIFont systemFontOfSize:14];
        self.nanoTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.nanoTitleLabel.textColor = [UIColor whiteColor];
        [self.nanoTitleLabel sizeToFit];
        [self.nanoStackView addArrangedSubview:self.nanoTitleLabel];
    }

    if (!self.nanoTextLabel && content.message) {
        self.nanoTextLabel = [[UILabel alloc] initWithFrame:self.nanoMarqueeView.bounds];
        self.nanoTextLabel.text = content.message;
        self.nanoTextLabel.font = [UIFont systemFontOfSize:14];
        self.nanoTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.nanoTextLabel.textColor = [UIColor whiteColor];
        [self.nanoTextLabel sizeToFit];
        [self.nanoStackView addArrangedSubview:self.nanoTextLabel];
    }

    if (content.message) {
        NSString *isoLangCode = (__bridge_transfer NSString*)CFStringTokenizerCopyBestStringLanguage((__bridge CFStringRef)content.message, CFRangeMake(0, content.message.length));
        NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:isoLangCode];
        if (direction == NSLocaleLanguageDirectionRightToLeft) {
            isLTR = NO;
        }
    }

    [self.nanoStackView setNeedsLayout];
    [self.nanoStackView layoutIfNeeded];

    CGSize stackViewSize = [self.nanoStackView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    [self.nanoStackView setFrame:CGRectMake(0, 0, stackViewSize.width, stackViewSize.height)];

    if (isLTR) {
        self.nanoMarqueeView.animationDirection = 0;
        self.nanoStackView.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        self.nanoMarqueeView.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    } else {
        self.nanoStackView.frame = CGRectMake(self.nanoMarqueeView.frame.size.width - stackViewSize.width, 0, stackViewSize.width, stackViewSize.height);
        self.nanoMarqueeView.animationDirection = 1;
        self.nanoStackView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        self.nanoMarqueeView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    }

    if ([self respondsToSelector:@selector(ntfConfig)]) {
        NTFConfig *config = [self ntfConfig];
        if (![config enabled]) return;

        if ([config colorizeBackground]) {
            if ([config dynamicBackgroundColor]) {
                [self.nanoView setBackgroundColor:self.ntfDynamicColor];
            } else {
                [self.nanoView setBackgroundColor:[config backgroundColor]];
            }
        }

        if ([config outline]) {
            self.nanoView.layer.borderWidth = [config outlineThickness];
            if ([config dynamicOutlineColor]) {
                self.nanoView.layer.borderColor = self.ntfDynamicColor.CGColor;
            } else {
                self.nanoView.layer.borderColor = [config outlineColor].CGColor;
            }
        }

        if ([config colorizeHeader]) {
            if ([config dynamicHeaderColor]) {
                [self.nanoAppLabel setTextColor:self.ntfDynamicColor];
            } else {
                [self.nanoAppLabel setTextColor:[config headerColor]];
            }
        }

        if ([config colorizeContent]) {
            if ([config dynamicContentColor]) {
                [self.nanoTextLabel setTextColor:self.ntfDynamicColor];
            } else {
                [self.nanoTextLabel setTextColor:[config contentColor]];
            }
        }

        self.nanoView.layer.cornerRadius = [config cornerRadius];
        self.nanoIconView.hidden = [config hideIcon];
        self.nanoAppLabel.hidden = [config hideAppName];
    }

    [self.nanoMarqueeView setContentSize:stackViewSize];
    [self.nanoMarqueeView invalidateIntrinsicContentSize];
    [self.nanoMarqueeView setMarqueeEnabled:YES];
    [self.nanoMarqueeView setNeedsLayout];
    [self.nanoMarqueeView layoutIfNeeded];
    [self.nanoView setNeedsLayout];
    [self.nanoView layoutIfNeeded];
}

%end

%end

%group NanobannersIntegrityFail

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (!dpkgInvalid) return;
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of Nanobanners you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Nanobanners is free. Uninstall this build and install the proper version of Nanobanners from:\nhttps://repo.nepeta.me/\n(it's free, damnit, why would you pirate that!?)"
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
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.nanobanners.list"];

    if (dpkgInvalid) {
        %init(NanobannersIntegrityFail);
        return;
    }
    
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.nanobanners"];

    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerFloat:&marqueeDelay default:3 forKey:@"MarqueeDelay"];
    [preferences registerFloat:&marqueeScrollRate default:30 forKey:@"MarqueeScrollRate"];

    %init(Nanobanners);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)fakeBanner, (CFStringRef)@"me.nepeta.nanobanners/TestBanner", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
