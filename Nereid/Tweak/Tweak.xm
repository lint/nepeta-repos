#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>
#import <Nepeta/NEPColorUtils.h>
#import <AudioToolbox/AudioToolbox.h>
#import <libcolorpicker.h>
#import "Tweak.h"

HBPreferences *preferences;

BOOL dpkgInvalid = false;

BOOL swapArtistAndTitle;
BOOL replaceIcons;
BOOL artworkAsBackground;
BOOL changeControlsLayout;
BOOL removeAlbumName;
BOOL hideVolumeSlider;
BOOL hideTimeLabels;
BOOL showMiddleButtonCircle;
BOOL colorizeDateAndTime;
BOOL hapticFeedback;
BOOL hideClockWhilePlaying;
BOOL alwaysShowPlayer;
NSInteger blurRadius = 0;
NSInteger darken = 0;
NSInteger color = 0;
NSInteger artworkMode = 0;

NSInteger extraButtonLeft = 0;
NSInteger extraButtonRight = 0;

UIImageView *artworkView = nil;
CGFloat alpha = 1; //default 0.667

UniversalNRDController *lastController = nil;
SBFLockScreenDateView *lastDateView = nil;
SBDashBoardNotificationAdjunctListViewController *adjunctListViewController = nil;

BOOL isShuffle = 0;
int isRepeat = 0;

BOOL hasArtwork = NO;

@implementation NRDManager

+(instancetype)sharedInstance {
    static NRDManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NRDManager alloc];
        sharedInstance.mainColor = [UIColor whiteColor];
        sharedInstance.fallbackColor = [UIColor whiteColor];
        sharedInstance.artworkBackgroundColor = [UIColor blackColor];
        [sharedInstance reloadColors];
    });
    return sharedInstance;
}

-(id)init {
    return [NRDManager sharedInstance];
}

-(void)reloadColors {
    NSDictionary *colors = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.nepeta.nereid-colors.plist"];
    if (!colors) return;

    if (color == 3) self.mainColor = [LCPParseColorString([colors objectForKey:@"CustomColor"], @"#ffffff:1.0") copy];
    self.fallbackColor = [LCPParseColorString([colors objectForKey:@"CustomColor"], @"#ffffff:1.0") copy];
    self.artworkBackgroundColor = [LCPParseColorString([colors objectForKey:@"ArtworkBackgroundColor"], @"#000000:1.0") copy];

    if (lastController && [lastController respondsToSelector:@selector(nrdUpdate)] && color == 3) [lastController nrdUpdate];
    if (artworkView) artworkView.backgroundColor = [self.artworkBackgroundColor copy];
}

@end

%group Nereid

%hook SBFLockScreenDateView

-(id)initWithFrame:(CGRect)arg1 {
    %orig;
    lastDateView = self;
    return self;
}

%new
-(void)nrdUpdate {
    if (!artworkView) return;
    
    UIColor *color = [NRDManager sharedInstance].legibilityColor;
    if (colorizeDateAndTime && artworkAsBackground && artworkView && artworkView.hidden == NO) {
        color = [NRDManager sharedInstance].mainColor;
    }

    if (!color) return;

    for (id view in [self subviews]) {
        if ([view isKindOfClass:%c(SBUILegibilityLabel)]) {
            SBUILegibilityLabel *label = view;
            if (![NRDManager sharedInstance].legibilityColor) {
                [NRDManager sharedInstance].legibilityColor = label.legibilitySettings.primaryColor;
            }
            label.legibilitySettings.primaryColor = color;
            [label _updateLegibilityView];
            [label _updateLabelForLegibilitySettings];
        } else if ([view isKindOfClass:%c(SBFLockScreenDateSubtitleView)]) {
            for (id subview in [view subviews]) {
                if ([subview isKindOfClass:%c(SBUILegibilityLabel)]) {
                    SBUILegibilityLabel *label = subview;
                    if (![NRDManager sharedInstance].legibilityColor) {
                        [NRDManager sharedInstance].legibilityColor = label.legibilitySettings.primaryColor;
                    }
                    label.legibilitySettings.primaryColor = color;
                    [label _updateLegibilityView];
                    [label _updateLabelForLegibilitySettings];
                }
            }
        }
    }
}

%end

%hook SBDashBoardNotificationAdjunctListViewController

-(id)init {
    %orig;
    adjunctListViewController = self;
    return self;
}

-(BOOL)_shouldShowMediaControls {
    if (alwaysShowPlayer) return YES;
    return %orig;
}

-(BOOL)isShowingMediaControls {
    if (alwaysShowPlayer) return YES;
    return %orig;
}

-(void)_didUpdateDisplay {
    %orig;
    if (hideClockWhilePlaying) lastDateView.hidden = [self isShowingMediaControls];
    if (lastController && [lastController respondsToSelector:@selector(nrdUpdate)] && [self isShowingMediaControls]) [lastController nrdUpdate];
    if (artworkView) artworkView.hidden = (!artworkAsBackground || ![self isShowingMediaControls] || !hasArtwork);
}

%end

%hook SBDashBoardAdjunctItemView

%new
-(id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

-(void)layoutSubviews {
    %orig;
    if ([self valueForKey:@"_mainOverlayView"]) {
        self.backgroundMaterialView.alpha = 0.0;
        UIView *overlayView = [self valueForKey:@"_mainOverlayView"];
        overlayView.alpha = 0.0;
    } else if ([self valueForKey:@"_platterView"]) {
        PLPlatterView *platterView = [self valueForKey:@"_platterView"];
        platterView.backgroundMaterialView.alpha = 0.0;
        platterView.mainOverlayView.alpha = 0.0;
    }
}

%end

%hook SBMediaController

%property (nonatomic, retain) NSData *nrdLastImageData;

-(void)setNowPlayingInfo:(id)arg1 {
    %orig;

    if (!artworkAsBackground) return;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict = (__bridge NSDictionary *)information;
        
        if (dict) {
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
                UIImage *image = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
                if (!image) return;
                hasArtwork = YES;
                
                if (self.nrdLastImageData && [self.nrdLastImageData isEqualToData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]) return;
                self.nrdLastImageData = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData];
                
                UIImage *toImage = image;
                if (blurRadius > 0 || darken > 0) {
                    toImage = [image darkened:((CGFloat)darken/100.0f) andBlurredImage:blurRadius];
                }

                if ([self nowPlayingApplication] && [[self nowPlayingApplication] bundleIdentifier] &&
                        [[[self nowPlayingApplication] bundleIdentifier] isEqualToString:@"com.spotify.client"] &&
                        image.size.height == 600 && image.size.width == 600) { //spotify's placeholder image
                    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
                    const UInt8* data = CFDataGetBytePtr(pixelData);
                    int bytes = CFDataGetLength(pixelData);
                    int multiplier = 4;

                    if (bytes == image.size.height * image.size.width * 3) {
                        multiplier = 3;
                    }

                    int checked = 0;
                    NSArray *toCheck = @[@[@30, @30], @[@570, @30], @[@30, @570], @[@570, @570]];

                    for (NSArray *array in toCheck) {
                        int pixelInfo = ((image.size.width * [array[0] intValue]) + [array[1] intValue]) * multiplier;
                        UInt8 red   = data[pixelInfo + 0];
                        UInt8 green = data[pixelInfo + 1];
                        UInt8 blue  = data[pixelInfo + 2];

                        if (red == 40 && green == 40 && blue == 40) checked++;
                        else break;
                    }

                    CFRelease(pixelData);

                    if ([toCheck count] == checked) { // spotify placeholder image detected
                        return;
                    }
                }

                [UIView transitionWithView:artworkView duration:0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    artworkView.image = toImage;
                } completion:nil];

                if (color == 0 || color == 2) {
                    if (color == 2) {
                        NEPPalette *palette = [NEPColorUtils averageColors:image withAlpha:1.0];
                        [NRDManager sharedInstance].mainColor = palette.background;
                    }

                    if (color == 0) {
                        CGRect croppingRect = CGRectMake(toImage.size.width/2 - toImage.size.width/5, toImage.size.height/2 - toImage.size.height/10, toImage.size.width/2.5, toImage.size.height/5);
                        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, [toImage scale]);
                        [toImage drawAtPoint:CGPointMake(-croppingRect.origin.x, -croppingRect.origin.y)];
                        UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        UIColor *color = [NEPColorUtils averageColor:croppedImage withAlpha:1.0];

                        if ([NEPColorUtils isDark:color]) {
                            [NRDManager sharedInstance].mainColor = [UIColor whiteColor];
                        } else {
                            [NRDManager sharedInstance].mainColor = [UIColor blackColor];
                        }
                    }
                }
            }
        }

        if (color == 3) {
            [NRDManager sharedInstance].mainColor = [NRDManager sharedInstance].fallbackColor;
        }
        
        if (artworkView && adjunctListViewController) artworkView.hidden = (!artworkAsBackground || ![adjunctListViewController isShowingMediaControls] || !hasArtwork);

        if (lastController && [lastController respondsToSelector:@selector(nrdUpdate)]) [lastController nrdUpdate];
        if (lastDateView && [lastDateView respondsToSelector:@selector(nrdUpdate)]) [lastDateView nrdUpdate];
    });
}

%end

%hook SBDashBoardViewController

%property (nonatomic, retain) UIImageView *nrdArtworkView;

-(void)viewWillAppear:(BOOL)animated {
    %orig;
    if (!self.nrdArtworkView) {
        self.nrdArtworkView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view insertSubview:self.nrdArtworkView atIndex:0];
        self.nrdArtworkView.hidden = NO;
        self.nrdArtworkView.image = [UIImage new];
        self.nrdArtworkView.backgroundColor = [[NRDManager sharedInstance].artworkBackgroundColor copy];
    }

    artworkView = self.nrdArtworkView;
    
    if (artworkMode == 0) self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFill;
    else self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFit;

    if (adjunctListViewController) self.nrdArtworkView.hidden = (!artworkAsBackground || ![adjunctListViewController isShowingMediaControls] || !hasArtwork);
    else self.nrdArtworkView.hidden = YES;

    if (lastDateView && [lastDateView respondsToSelector:@selector(nrdUpdate)]) [lastDateView nrdUpdate];

    self.nrdArtworkView.frame = self.view.bounds;
}

-(void)viewDidLayoutSubviews {
    %orig;
    [self.view sendSubviewToBack:self.nrdArtworkView];
    self.nrdArtworkView.frame = self.view.bounds;
}

%end

%hook MediaControlsPanelViewController

%property (nonatomic, assign) BOOL nrdEnabled;

-(void)setStyle:(NSInteger)style {
    if (style == 3) { // 0 for reachit full
        self.nrdEnabled = YES;
        self.parentContainerView.mediaControlsContainerView.mediaControlsTimeControl.nrdEnabled = YES;
        self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView.nrdEnabled = YES;
        self.headerView.nrdEnabled = YES;

        lastController = self;
    } else {
        self.nrdEnabled = NO;
        self.parentContainerView.mediaControlsContainerView.mediaControlsTimeControl.nrdEnabled = NO;
        self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView.nrdEnabled = NO;
        self.headerView.nrdEnabled = NO;
    }

    %orig;
}

%new
-(void)nrdUpdate {
    if (!self.nrdEnabled) return;

    [self.parentContainerView.mediaControlsContainerView.mediaControlsTimeControl nrdUpdate];
    [self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView nrdUpdate];
    [self.headerView nrdUpdate];
    [self.volumeContainerView nrdUpdate];

    [self.parentContainerView setNeedsLayout];
    [self.parentContainerView layoutIfNeeded];
    [self.parentContainerView.mediaControlsContainerView setNeedsLayout];
    [self.parentContainerView.mediaControlsContainerView layoutIfNeeded];
    [self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView setNeedsLayout];
    [self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView layoutIfNeeded];
}

-(void)viewWillLayoutSubviews {
    %orig;
    if (!self.nrdEnabled) return;
    self.volumeContainerView.hidden = (hideVolumeSlider);
}

-(void)viewWillAppear:(BOOL)animated {
    %orig;
    if (!self.nrdEnabled) return;
    if (lastDateView && [lastDateView respondsToSelector:@selector(nrdUpdate)]) [lastDateView nrdUpdate];
    [self.parentContainerView setNeedsLayout];
    [self.parentContainerView layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated {
    %orig;
    if (!self.nrdEnabled) return;
    [self.parentContainerView setNeedsLayout];
    [self.parentContainerView layoutIfNeeded];
    [self.parentContainerView.mediaControlsContainerView setNeedsLayout];
    [self.parentContainerView.mediaControlsContainerView layoutIfNeeded];
    [self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView setNeedsLayout];
    [self.parentContainerView.mediaControlsContainerView.mediaControlsTransportStackView layoutIfNeeded];
}

%end

/* Thanks to iOS 12.2 we get this nasty shit reeee */

%hook MRPlatterViewController

%property (nonatomic, assign) BOOL nrdEnabled;

-(void)setStyle:(NSInteger)style {
    if (style == 3) { // 0 for reachit full
        self.nrdEnabled = YES;
        self.parentContainerView.containerView.timeControl.nrdEnabled = YES;
        self.parentContainerView.containerView.transportStackView.nrdEnabled = YES;
        self.nowPlayingHeaderView.nrdEnabled = YES;

        lastController = self;
    } else {
        self.nrdEnabled = NO;
        self.parentContainerView.containerView.timeControl.nrdEnabled = NO;
        self.parentContainerView.containerView.transportStackView.nrdEnabled = NO;
        self.nowPlayingHeaderView.nrdEnabled = NO;
    }

    %orig;
}

%new
-(void)nrdUpdate {
    if (!self.nrdEnabled) return;

    [self.parentContainerView.containerView.timeControl nrdUpdate];
    [self.parentContainerView.containerView.transportStackView nrdUpdate];
    [self.nowPlayingHeaderView nrdUpdate];
    [self.volumeContainerView nrdUpdate];

    [self.parentContainerView setNeedsLayout];
    [self.parentContainerView layoutIfNeeded];
    [self.parentContainerView.containerView setNeedsLayout];
    [self.parentContainerView.containerView layoutIfNeeded];
    [self.parentContainerView.containerView.transportStackView setNeedsLayout];
    [self.parentContainerView.containerView.transportStackView layoutIfNeeded];
}

-(void)viewWillLayoutSubviews {
    %orig;
    if (!self.nrdEnabled) return;
    self.volumeContainerView.hidden = (hideVolumeSlider);
}

-(void)viewWillAppear:(BOOL)animated {
    %orig;
    if (!self.nrdEnabled) return;
    if (lastDateView && [lastDateView respondsToSelector:@selector(nrdUpdate)]) [lastDateView nrdUpdate];
    [self.parentContainerView setNeedsLayout];
    [self.parentContainerView layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated {
    %orig;
    if (!self.nrdEnabled) return;
    [self.parentContainerView setNeedsLayout];
    [self.parentContainerView layoutIfNeeded];
    [self.parentContainerView.containerView setNeedsLayout];
    [self.parentContainerView.containerView layoutIfNeeded];
    [self.parentContainerView.containerView.transportStackView setNeedsLayout];
    [self.parentContainerView.containerView.transportStackView layoutIfNeeded];
}

%end

%hook MPUMarqueeView

%property (nonatomic, assign) BOOL nrdEnabled;

-(void)layoutSubviews {
    if (self.nrdEnabled && [self.contentView subviews] && [[self.contentView subviews] count] > 0) {
        UIView *view = [self.contentView subviews][0];

        CGRect frame = view.frame;
        if (frame.size.width < self.bounds.size.width) {
            view.frame = CGRectMake(0, frame.origin.y, self.bounds.size.width, frame.size.height);
        }

        if (frame.size.width > self.bounds.size.width) {
            view.frame = CGRectMake(6, frame.origin.y, frame.size.width, frame.size.height);
        }
    }

    %orig;

    if (!self.nrdEnabled) return;
    CGRect cvFrame = self.contentView.frame;
    self.contentView.frame = CGRectMake(0, cvFrame.origin.y, cvFrame.size.width, cvFrame.size.height);
}

%end

%hook MediaControlsHeaderView

%property (nonatomic, assign) BOOL nrdEnabled;

-(void)setSecondaryString:(NSString *)arg1 {
    if (self.nrdEnabled && removeAlbumName && [arg1 containsString:@" — "]) {
        NSArray *split = [arg1 componentsSeparatedByString:@" — "];
        arg1 = split[0];
    }

    %orig;
}

-(void)_updateStyle {
    %orig;
    [self nrdUpdate];
}

-(CGSize)layoutTextInAvailableBounds:(CGRect)arg1 setFrames:(BOOL)arg2 {
    CGSize orig = %orig;
    [self nrdUpdate];
    return orig;
}

-(void)layoutSubviews {
    %orig;
    if (!self.nrdEnabled) return;
    
    /* Remove routing stuff */
    [self.routingButton removeFromSuperview];
    if ([self respondsToSelector:@selector(routeLabel)]) [self.routeLabel removeFromSuperview];
    if ([self respondsToSelector:@selector(titleLabel)]) [self.titleLabel removeFromSuperview];

    /* Remove artwork view */
    [self.artworkView removeFromSuperview];
    [self.placeholderArtworkView removeFromSuperview];
    if ([self respondsToSelector:@selector(artworkBackgroundView)]) [self.artworkBackgroundView removeFromSuperview];
    if ([self respondsToSelector:@selector(artworkBackground)]) [self.artworkBackground removeFromSuperview];
    [self.shadow removeFromSuperview];

    /* Remove scrolling text */

    self.primaryLabel.textAlignment = NSTextAlignmentCenter;
    self.secondaryLabel.textAlignment = NSTextAlignmentCenter;

    self.primaryMarqueeView.frame = CGRectMake(0, self.primaryMarqueeView.frame.origin.y, self.bounds.size.width, self.primaryMarqueeView.frame.size.height);
    self.secondaryMarqueeView.frame = CGRectMake(0, self.secondaryMarqueeView.frame.origin.y, self.bounds.size.width, self.secondaryMarqueeView.frame.size.height);

    if (swapArtistAndTitle) {
        CGRect temp = self.primaryMarqueeView.frame;
        self.primaryMarqueeView.frame = self.secondaryMarqueeView.frame;
        self.secondaryMarqueeView.frame = temp;
    }

    [self nrdUpdate];
}

-(void)didMoveToWindow {
    %orig;
    [self nrdUpdate];
}

%new
-(void)nrdUpdate {
    self.primaryMarqueeView.nrdEnabled = self.nrdEnabled;
    self.secondaryMarqueeView.nrdEnabled = self.nrdEnabled;
    
    if (!self.nrdEnabled) return;
    self.secondaryLabel.font = [UIFont systemFontOfSize:13];

    if (color == 1) return;
    self.primaryLabel.layer.compositingFilter = nil;
    self.primaryLabel.alpha = alpha;
    self.primaryLabel.textColor = [[NRDManager sharedInstance].mainColor copy];

    self.secondaryLabel.layer.compositingFilter = nil;
    self.secondaryLabel.alpha = alpha;
    self.secondaryLabel.textColor = [[NRDManager sharedInstance].mainColor copy];
}

%end

%hook MediaControlsTimeControl

%property (nonatomic, assign) BOOL nrdEnabled;

-(void)layoutSubviews {
    %orig;
    if (!self.nrdEnabled || color == 1) return;

    [self nrdUpdate];

    self.elapsedTimeLabel.hidden = hideTimeLabels;
    self.remainingTimeLabel.hidden = hideTimeLabels;
}

%new
-(void)nrdUpdate {
    self.elapsedTrack.layer.compositingFilter = nil;
    self.remainingTrack.layer.compositingFilter = nil;
    self.knobView.layer.compositingFilter = nil;
    self.elapsedTimeLabel.layer.compositingFilter = nil;
    self.remainingTimeLabel.layer.compositingFilter = nil;

    self.elapsedTrack.layer.filters = nil;
    self.remainingTrack.layer.filters = nil;
    self.knobView.layer.filters = nil;
    self.elapsedTimeLabel.layer.filters = nil;
    self.remainingTimeLabel.layer.filters = nil;

    self.remainingTrack.alpha = 0.5;

    [self.elapsedTrack setBackgroundColor:[[NRDManager sharedInstance].mainColor copy]];
    [self.remainingTrack setBackgroundColor:[[NRDManager sharedInstance].mainColor copy]];
    [self.knobView setBackgroundColor:[[NRDManager sharedInstance].mainColor copy]];
    [self.elapsedTimeLabel setTextColor:[[NRDManager sharedInstance].mainColor copy]];
    [self.remainingTimeLabel setTextColor:[[NRDManager sharedInstance].mainColor copy]];
}

%end

%hook MPVolumeSlider

%property (nonatomic, assign) BOOL nrdEnabled;

-(id)_thumbImageForStyle:(long long)arg1 {
    if (!self.nrdEnabled) return %orig;

    UIImage *orig = %orig;

    CIImage *inputImage = [[CIImage alloc] initWithImage:orig];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIColorInvert"];
    [compositeFilter setValue:inputImage forKey:@"inputImage"];
    CIImage *outputImage = [compositeFilter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:inputImage.extent];
    UIImage *finalImage = [[UIImage imageWithCGImage:cgimg scale:orig.scale orientation:UIImageOrientationUp] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGImageRelease(cgimg);

    return finalImage;
}

%end

%hook MediaControlsVolumeContainerView

%property (nonatomic, assign) BOOL nrdEnabled;

%new
-(void)nrdUpdate {
    self.volumeSlider.nrdEnabled = YES;
    self.volumeSlider.layer.filters = nil;
    self.volumeSlider.layer.compositingFilter = nil;

    [self.volumeSlider _minTrackView].layer.filters = nil;
    [self.volumeSlider _minTrackView].layer.compositingFilter = nil;

    [self.volumeSlider _maxTrackView].layer.filters = nil;
    [self.volumeSlider _maxTrackView].layer.compositingFilter = nil;

    [self.volumeSlider _minValueView].layer.filters = nil;
    [self.volumeSlider _minValueView].layer.compositingFilter = nil;
    [self.volumeSlider _minValueView].image = [[self.volumeSlider _minValueView].image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.volumeSlider _minValueView].tintColor = [[NRDManager sharedInstance].mainColor copy];

    [self.volumeSlider _maxValueView].layer.filters = nil;
    [self.volumeSlider _maxValueView].layer.compositingFilter = nil;
    [self.volumeSlider _maxValueView].image = [[self.volumeSlider _maxValueView].image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.volumeSlider _maxValueView].tintColor = [[NRDManager sharedInstance].mainColor copy];

    self.volumeSlider.minimumTrackTintColor = [[NRDManager sharedInstance].mainColor copy];
    self.volumeSlider.maximumTrackTintColor = [[NRDManager sharedInstance].mainColor copy];

    UIImageView *thumbView = (UIImageView *)[self.volumeSlider thumbView];
    thumbView.tintColor = [[NRDManager sharedInstance].mainColor copy];
}

%end

%hook MediaControlsTransportStackView

%property (nonatomic, retain) MediaControlsTransportButton * nrdLeftButton;
%property (nonatomic, retain) MediaControlsTransportButton * nrdRightButton;
%property (nonatomic, retain) UIView * nrdCircleView;
%property (nonatomic, assign) BOOL nrdEnabled;

-(void)layoutSubviews {
    %orig;
    if (!self.nrdEnabled) {
        if (self.nrdCircleView) self.nrdCircleView.hidden = YES;
        if (self.nrdLeftButton) self.nrdLeftButton.hidden = YES;
        if (self.nrdRightButton) self.nrdRightButton.hidden = YES;
        return;
    }

    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;

    if (!self.nrdCircleView) {
        self.nrdCircleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,58,58)];
        self.nrdCircleView.layer.cornerRadius = 28;
        self.nrdCircleView.layer.borderWidth = 2.0f;
        self.nrdCircleView.layer.borderColor = [NRDManager sharedInstance].mainColor.CGColor;

        [self addSubview:self.nrdCircleView];
        [self sendSubviewToBack:self.nrdCircleView];
    }

    if (!self.nrdLeftButton) {
        self.nrdLeftButton = [[%c(MediaControlsTransportButton) alloc] initWithFrame:self.middleButton.frame];
        self.nrdLeftButton.imageEdgeInsets = UIEdgeInsetsMake(2.5f, 5.0f, 2.5f, 5.0f);
        self.nrdLeftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.nrdLeftButton addTarget:self action:@selector(nrdLeftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nrdLeftButton];
    }

    if (!self.nrdRightButton) {
        self.nrdRightButton = [[%c(MediaControlsTransportButton) alloc] initWithFrame:self.middleButton.frame];
        self.nrdRightButton.imageEdgeInsets = UIEdgeInsetsMake(2.5f, 5.0f, 2.5f, 5.0f);
        self.nrdRightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.nrdRightButton addTarget:self action:@selector(nrdRightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nrdRightButton];
    }

    self.nrdLeftButton.hidden = extraButtonLeft == 0;
    self.nrdRightButton.hidden = extraButtonRight == 0;

    [self _updateButtonImage:nil button:self.nrdLeftButton];
    [self _updateButtonImage:nil button:self.nrdRightButton];

    self.nrdCircleView.frame = CGRectMake(self.middleButton.frame.origin.x + self.middleButton.frame.size.width/2 - 28,
                                            self.middleButton.frame.origin.y + self.middleButton.frame.size.height/2 - 28,
                                            56, 56);

    self.nrdCircleView.hidden = !showMiddleButtonCircle;
    
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(2.5f, 5.0f, 2.5f, 5.0f);

    self.middleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.middleButton.imageEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);

    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(2.5f, 5.0f, 2.5f, 5.0f);

    self.leftButton.frame = CGRectMake(self.nrdCircleView.frame.origin.x - self.leftButton.frame.size.width * 2.0, self.leftButton.frame.origin.y, self.leftButton.frame.size.width, self.leftButton.frame.size.height);
    self.rightButton.frame = CGRectMake(self.nrdCircleView.frame.origin.x + self.nrdCircleView.frame.size.width + self.rightButton.frame.size.width, self.rightButton.frame.origin.y, self.rightButton.frame.size.width, self.rightButton.frame.size.height);

    self.nrdLeftButton.frame = CGRectMake(self.nrdCircleView.frame.origin.x - self.leftButton.frame.size.width * 2.0 - self.nrdLeftButton.frame.size.width * 1.5, self.middleButton.frame.origin.y, self.nrdLeftButton.frame.size.width, self.nrdLeftButton.frame.size.height);
    self.nrdRightButton.frame = CGRectMake(self.nrdCircleView.frame.origin.x + self.nrdCircleView.frame.size.width + self.rightButton.frame.size.width * 2.0 + self.nrdRightButton.frame.size.width * 0.5, self.middleButton.frame.origin.y, self.nrdRightButton.frame.size.width, self.nrdRightButton.frame.size.height);

    [self nrdUpdate];
}

-(void)buttonHoldBegan:(MediaControlsTransportButton *)button {
    %orig;
    if (!self.nrdEnabled || color == 1) return;
    [button setTintColor:[[NRDManager sharedInstance].mainColor copy]];
}

-(void)buttonHoldReleased:(MediaControlsTransportButton *)button {
    %orig;
    if (!self.nrdEnabled || color == 1) return;
    [button setTintColor:[[NRDManager sharedInstance].mainColor copy]];
}

-(void)_updateButtonImage:(UIImage *)image button:(MediaControlsTransportButton *)button {
    if (self.nrdEnabled) {
        UIImage *newImage = nil;
        if (button == self.leftButton && replaceIcons && !button.shouldPresentActionSheet) {
            newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/back.png"]
                            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (button == self.rightButton && replaceIcons && !button.shouldPresentActionSheet) {
            newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/forward.png"]
                            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (button == self.nrdLeftButton) {
            switch (extraButtonLeft) {
                case 1:
                    newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/shuffle.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    break;
                case 2:
                    if (isRepeat == 2 || isRepeat == 0) {
                        newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/repeat.png"]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    } else {
                        newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/repeatonce.png"]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    }
                    break;
                case 3:
                    newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/back15.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    break;
                case 4:
                    newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/route.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    break;
            }
        } else if (button == self.nrdRightButton) {
            switch (extraButtonRight) {
                case 1:
                    newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/shuffle.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    break;
                case 2:
                    if (isRepeat == 2 || isRepeat == 0) {
                        newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/repeat.png"]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    } else {
                        newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/repeatonce.png"]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    }
                    break;
                case 3:
                    newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/forward15.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    break;
                case 4:
                    newImage = [[UIImage imageWithContentsOfFile:@"/Library/Nereid/route.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    break;
            }
        }
        
        if (newImage) {
            CGFloat height = self.middleButton.imageView.frame.size.height;
            CGFloat ratio = height/(newImage.size.height);
            CGFloat width = newImage.size.width * ratio;
            CGSize newSize = CGSizeMake(width, height);

            UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
            [newImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();    
            UIGraphicsEndImageContext();
        }
    }
 
    %orig;
    if (!self.nrdEnabled || color == 1) return;
    button.imageView.alpha = alpha;
    button.imageView.layer.filters = nil;
    button.imageView.layer.compositingFilter = nil;
    [button setTintColor:[[NRDManager sharedInstance].mainColor copy]];
}

-(void)_updateButtonBlendMode:(MediaControlsTransportButton *)button {
    if (!self.nrdEnabled || color == 1) %orig;
    button.imageView.alpha = alpha;
    button.imageView.layer.filters = nil;
    button.imageView.layer.compositingFilter = nil;
    [button setTintColor:[[NRDManager sharedInstance].mainColor copy]];
}

-(void)touchUpInsideLeftButton:(id)arg1 {
    %orig;
    if (hapticFeedback) AudioServicesPlaySystemSound(1519);
}

-(void)touchUpInsideMiddleButton:(id)arg1 {
    %orig;
    if (hapticFeedback) AudioServicesPlaySystemSound(1519);
}

-(void)touchUpInsideRightButton:(id)arg1 {
    %orig;
    if (hapticFeedback) AudioServicesPlaySystemSound(1519);
}

%new
-(void)nrdLeftButtonPressed:(id)sender {
    if (hapticFeedback) AudioServicesPlaySystemSound(1519);
    switch (extraButtonLeft) {
        case 1:
            MRMediaRemoteSendCommand(MRMediaRemoteCommandAdvanceShuffleMode, nil);
            break;
        case 2:
            MRMediaRemoteSendCommand(MRMediaRemoteCommandAdvanceRepeatMode, nil);
            break;
        case 3:
            MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
                NSDictionary *dict = (__bridge NSDictionary *)information;

                if (dict && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime]) {
                    int elapsedTime = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] intValue];
                    MRMediaRemoteSetElapsedTime(elapsedTime - 15);
                }
            });
            break;
        case 4:
            [lastController _presentRoutingViewControllerFromCoverSheet];
            break;
    }
}

%new
-(void)nrdRightButtonPressed:(id)sender {
    if (hapticFeedback) AudioServicesPlaySystemSound(1519);
    switch (extraButtonRight) {
        case 1:
            MRMediaRemoteSendCommand(MRMediaRemoteCommandAdvanceShuffleMode, nil);
            break;
        case 2:
            MRMediaRemoteSendCommand(MRMediaRemoteCommandAdvanceRepeatMode, nil);
            break;
        case 3:
            MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
                NSDictionary *dict = (__bridge NSDictionary *)information;

                if (dict && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime]) {
                    int elapsedTime = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] intValue];
                    MRMediaRemoteSetElapsedTime(elapsedTime + 15);
                }
            });
            break;
        case 4:
            [lastController _presentRoutingViewControllerFromCoverSheet];
            break;
    }
}

%new
-(void)nrdUpdate {
    if (color != 1) {
        self.leftButton.imageView.layer.filters = nil;
        self.leftButton.imageView.layer.compositingFilter = nil;
        self.leftButton.imageView.alpha = alpha;
        [self.leftButton.imageView setTintColor:[[NRDManager sharedInstance].mainColor copy]];

        self.middleButton.imageView.layer.filters = nil;
        self.middleButton.imageView.layer.compositingFilter = nil;
        self.middleButton.imageView.alpha = alpha;
        self.middleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.middleButton.imageView setTintColor:[[NRDManager sharedInstance].mainColor copy]];

        self.rightButton.imageView.layer.filters = nil;
        self.rightButton.imageView.layer.compositingFilter = nil;
        self.rightButton.imageView.alpha = alpha;
        [self.rightButton.imageView setTintColor:[[NRDManager sharedInstance].mainColor copy]];

        if (self.nrdCircleView) {
            self.nrdCircleView.layer.borderColor = self.middleButton.imageView.tintColor.CGColor;
            self.nrdCircleView.alpha = self.middleButton.imageView.alpha;
        }
    }

    isShuffle = NO;
    isRepeat = 0;
    MPCPlayerResponseTracklist *tracklist;

    if ([lastController respondsToSelector:@selector(response)]) {
        tracklist = [[lastController response] tracklist];
    } else if ([lastController respondsToSelector:@selector(endpointController)]) {
        tracklist = [[[lastController endpointController] response] tracklist];
    }
    
    isRepeat = [tracklist repeatType];
    isShuffle = [tracklist shuffleType];

    if (self.nrdLeftButton) {
        [self.nrdLeftButton.imageView setTintColor:[self.middleButton.imageView.tintColor copy]];
        self.nrdLeftButton.imageView.alpha = 1.0;
        if ((extraButtonLeft == 1 && !isShuffle) || (extraButtonLeft == 2 && isRepeat == 0)) {
            self.nrdLeftButton.imageView.alpha = 0.5;
        }
    }

    if (self.nrdRightButton) {
        [self.nrdRightButton.imageView setTintColor:[self.middleButton.imageView.tintColor copy]];
        if ((extraButtonRight == 1 && !isShuffle) || (extraButtonRight == 2 && isRepeat == 0)) {
            self.nrdRightButton.imageView.alpha = 0.5;
        }
    }
}

%end

%end

%group NereidIntegrityFail

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
    if (!dpkgInvalid) return;
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"😡😡😡"
        message:@"The build of Nereid you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Nereid is free. Uninstall this build and install the proper version of Nereid from:\nhttps://repo.nepeta.me/\n(it's free, damnit, why would you pirate that!?)"
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Damn!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [((UIApplication*)self).keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    }]];

    [((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end

%end

void reloadColors() {
    [[NRDManager sharedInstance] reloadColors];
}

%ctor {
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/me.nepeta.nereid.list"];

    if (dpkgInvalid) {
        %init(NereidIntegrityFail);
        return;
    }
    
    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.nereid"];
    
    [preferences registerBool:&artworkAsBackground default:YES forKey:@"ArtworkAsBackground"];
    [preferences registerBool:&changeControlsLayout default:YES forKey:@"ChangeControlsLayout"];
    [preferences registerBool:&removeAlbumName default:YES forKey:@"RemoveAlbumName"];
    [preferences registerBool:&hideVolumeSlider default:YES forKey:@"HideVolumeSlider"];
    [preferences registerBool:&hideTimeLabels default:YES forKey:@"HideTimeLabels"];
    [preferences registerBool:&showMiddleButtonCircle default:YES forKey:@"ShowMiddleButtonCircle"];
    [preferences registerBool:&replaceIcons default:YES forKey:@"ReplaceIcons"];
    [preferences registerBool:&colorizeDateAndTime default:YES forKey:@"ColorizeDateAndTime"];
    [preferences registerBool:&swapArtistAndTitle default:NO forKey:@"SwapArtistAndTitle"];
    [preferences registerBool:&hapticFeedback default:NO forKey:@"HapticFeedback"];
    [preferences registerBool:&hideClockWhilePlaying default:NO forKey:@"HideClockWhilePlaying"];
    [preferences registerBool:&alwaysShowPlayer default:NO forKey:@"AlwaysShowPlayer"];
    [preferences registerInteger:&extraButtonLeft default:0 forKey:@"ExtraButtonLeft"];
    [preferences registerInteger:&extraButtonRight default:0 forKey:@"ExtraButtonRight"];
    [preferences registerInteger:&blurRadius default:0 forKey:@"BlurRadius"];
    [preferences registerInteger:&darken default:0 forKey:@"Darken"];
    [preferences registerInteger:&color default:0 forKey:@"Color"];
    [preferences registerInteger:&artworkMode default:0 forKey:@"ArtworkMode"];

    %init(Nereid);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadColors, (CFStringRef)@"me.nepeta.nereid/ReloadColors", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
