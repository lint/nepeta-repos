#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541
#define MSHColorFlowInstalled [%c(CFWPrefsManager) class]
#define MSHColorFlowMusicEnabled MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_musicEnabled")
#define MSHColorFlowSpotifyEnabled MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_spotifyEnabled")
#define MSHCustomCoverInstalled [%c(CustomCoverAPI) class]

static SPTUniversalController *currentBackgroundMusicVC;
UIColor *const kTrans = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

%group MitsuhaVisuals

MSHJelloView *mshJelloView = NULL;

%hook SPTGeniusNowPlayingViewCoverArtView
-(void)layoutSubviews {
    %orig;
    if (mshJelloView != NULL && mshJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    [mshJelloView dynamicColor:self.image];
}
%end

%hook SPTNowPlayingCoverArtImageContentView
-(void)setImage:(UIImage *)image {
    %orig;
    if ((mshJelloView != NULL && mshJelloView.config.enableDynamicColor)) {
        [mshJelloView dynamicColor:image];
    }
}
%end

%hook SPTNowPlayingCoverArtViewCell
-(void)setSelected:(BOOL)selected {
    %orig;
    if (selected && self.shouldShowCoverArtView && (mshJelloView != NULL && mshJelloView.config.enableDynamicColor)) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    if (mshJelloView == NULL) return;
    [mshJelloView dynamicColor:self.cellContentRepresentation];
}
%end

%hook SPTNowPlayingShowsFormatBackgroundViewController
-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Spotify"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
    mshJelloView = self.mitsuhaJelloView;
    [self.view addSubview:self.mitsuhaJelloView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateVolume:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    [self applyCustomLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mitsuhaJelloView reloadConfig];

    CGFloat height = CGRectGetHeight(self.view.bounds) - self.mitsuhaJelloView.config.waveOffset;
    self.mitsuhaJelloView.frame = CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height);

    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
    %orig;
    self.mitsuhaJelloView.shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height/2 + self.mitsuhaJelloView.config.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [currentBackgroundMusicVC.mitsuhaJelloView updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdDisconnect];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
    } completion:^(BOOL finished){
        self.mitsuhaJelloView.shouldUpdate = false;
    }];
}

-(void)viewDidLayoutSubviews{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    [self.view bringSubviewToFront:self.mitsuhaJelloView];
}
%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(void)updateVolume:(NSNotification *)notification{
    if(self.mitsuhaJelloView.config.enableDynamicGain){
        float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        NSLog(@"[Mitsuha]: updateVolume: %lf", volume);
        self.mitsuhaJelloView.config.gain = pow(volume*15, 2);
    }
}
%end

%hook SPTNowPlayingBackgroundMusicViewController
-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Spotify"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
    mshJelloView = self.mitsuhaJelloView;
    [self.view addSubview:self.mitsuhaJelloView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateVolume:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    [self applyCustomLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mitsuhaJelloView reloadConfig];

    CGFloat height = CGRectGetHeight(self.view.bounds) - self.mitsuhaJelloView.config.waveOffset;
    self.mitsuhaJelloView.frame = CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height);

    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
    %orig;
    self.mitsuhaJelloView.shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height/2 + self.mitsuhaJelloView.config.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [currentBackgroundMusicVC.mitsuhaJelloView updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdDisconnect];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
    } completion:^(BOOL finished){
        self.mitsuhaJelloView.shouldUpdate = false;
    }];
}

-(void)viewDidLayoutSubviews{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    [self.view bringSubviewToFront:self.mitsuhaJelloView];
}
%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(void)updateVolume:(NSNotification *)notification{
    if(self.mitsuhaJelloView.config.enableDynamicGain){
        float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        NSLog(@"[Mitsuha]: updateVolume: %lf", volume);
        self.mitsuhaJelloView.config.gain = pow(volume*15, 2);
    }
}
%end

%hook SPTNowPlayingScrollViewController
-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Spotify"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds) - config.waveOffset;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
    mshJelloView = self.mitsuhaJelloView;
    [self.view insertSubview:self.mitsuhaJelloView atIndex:2];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateVolume:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mitsuhaJelloView reloadConfig];

    CGFloat height = CGRectGetHeight(self.view.bounds) - self.mitsuhaJelloView.config.waveOffset;
    self.mitsuhaJelloView.frame = CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height);

    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
    %orig;
    self.mitsuhaJelloView.shouldUpdate = true;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height/2 + self.mitsuhaJelloView.config.waveOffset);
        
    } completion:nil];
    
    
    currentBackgroundMusicVC = (SPTUniversalController*)self;
    
    //  Copied from NowPlayingImpl
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [currentBackgroundMusicVC.mitsuhaJelloView updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdDisconnect];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
    } completion:^(BOOL finished){
        self.mitsuhaJelloView.shouldUpdate = false;
    }];
}

%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(void)updateVolume:(NSNotification *)notification{
    if(self.mitsuhaJelloView.config.enableDynamicGain){
        float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        NSLog(@"[Mitsuha]: updateVolume: %lf", volume);
        self.mitsuhaJelloView.config.gain = pow(volume*15, 2);
    }
}
%end

/*
%hook SPTNowPlayingCoverArtViewCell

-(CGSize)cellSize{
    CGSize original = %orig;
    return CGSizeMake(original.width * 0.8, original.height * 0.8);
}

-(void)layoutSubviews{
    %orig;

    [self.superview sendSubviewToBack:self];
    if(currentBackgroundMusicVC.mitsuhaJelloView.config.enableCircleArtwork){
        self.contentView.layer.cornerRadius = self.contentView.frame.size.width/2;
        self.contentView.layer.masksToBounds = true;
    }
}

%end
*/

%hook SPTImageBlurView

-(void)layoutSubviews{
    %orig;
    [self applyCustomLayout];
}

-(void)updateBlurIntensity{
    %orig;
    [self applyCustomLayout];
}

-(void)updateFocusIfNeeded{
    %orig;
    [self applyCustomLayout];
}

%new
-(void)applyCustomLayout{
    if(MSHColorFlowInstalled){
        if([self viewWithTag:CFWBackgroundViewTagNumber]){
            [[self viewWithTag:CFWBackgroundViewTagNumber] removeFromSuperview];
        }
    }
    
    /*if([self.tintView.layer.sublayers count] == 0){
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.tintView.bounds;
        gradient.colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor];
        [gradient setName:@"GLayer"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tintView.layer addSublayer:gradient];
            [self.tintView setBackgroundColor:kTrans];
        });
    }*/
}

%new
-(void)updateGradientDark:(BOOL)darkbackground{
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        NSArray<UIColor *> *colors;
        
        if(darkbackground){
            colors = @[(id)[UIColor colorWithWhite:0 alpha:0.6].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor, (id)[UIColor clearColor].CGColor];
        }else{
            colors = @[(id)[UIColor colorWithWhite:0 alpha:1].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor];
        }
        
        for(CALayer *layer in [self.tintView.layer sublayers]){
            if([layer.name isEqualToString:@"GLayer"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"[Mitsuha]: Dark Background? %d\n%@", darkbackground, colors);
                    CAGradientLayer *gradient = (CAGradientLayer *)layer;
                    gradient.colors = colors;
                    [gradient setNeedsDisplay];
                });
            }
        }
    }
}

%end

%hook SPTNowPlayingModel

-(void)player:(id)arg1 stateDidChange:(id)arg2 fromState:(id)arg3{
    %orig;
    [self applyColorChange];
}

-(void)updateWithPlayerState:(id)arg1{
    %orig;
    [self applyColorChange];
}

%new
-(void)applyColorChange{
    if(MSHColorFlowInstalled && MSHColorFlowSpotifyEnabled){
        if(!currentBackgroundMusicVC.mitsuhaJelloView.config.ignoreColorFlow){
            CFWColorInfo *colorInfo = [[%c(CFWSpotifyStateManager) sharedManager] mainColorInfo];
            UIColor *backgroundColor = [[colorInfo backgroundColor] colorWithAlphaComponent:0.5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [currentBackgroundMusicVC.mitsuhaJelloView updateWaveColor:backgroundColor subwaveColor:backgroundColor];
                //[currentBackgroundMusicVC.backgroundView.backgroundImageBlurView updateGradientDark:colorInfo.backgroundDark];
            });
        }
    }
}

%end

%hook SpotifyAppDelegate

static BOOL registered;

-(void)applicationDidEnterBackground:(UIApplication *)application{
    currentBackgroundMusicVC.mitsuhaJelloView.shouldUpdate = false;
    
    if(!registered){
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(enableWave)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        registered = true;
    }
    
    %orig;
}

%new
-(void)enableWave{
    currentBackgroundMusicVC.mitsuhaJelloView.shouldUpdate = true;
}

%end

%end

%group MitsuhaSpotifyCoverArtFix

%hook SPTNowPlayingCarouselAreaViewController

static CGFloat originalCenterY = 0;

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    
    NSLog(@"[Mitsuha]: originalCenterY: %lf", originalCenterY);
    
    CGPoint center = self.view.coverArtView.center;
    
    self.view.coverArtView.alpha = 0;
    self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    
    NSLog(@"[Mitsuha]: viewDidAppear");
    
    CGPoint center = self.view.coverArtView.center;
    
    if(originalCenterY == 0){
        originalCenterY = center.y;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.coverArtView.alpha = 1.0;
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
    } completion:^(BOOL finished){
        if(self.view.coverArtView.center.y != originalCenterY * 0.8){    //  For some reason I can't explain
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
            } completion:nil];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    
    CGPoint center = self.view.coverArtView.center;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.coverArtView.alpha = 0;
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
    } completion:nil];
}

%end

%end

%ctor{
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Spotify"];

    if(config.enabled){
        %init(MitsuhaVisuals)
        if (config.enableCoverArtBugFix) {
            %init(MitsuhaSpotifyCoverArtFix)
        }
    }
}