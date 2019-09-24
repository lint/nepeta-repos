#import "Tweak.h"
#import "../MSHUtils.h"
#import "../Utils/MSHIsDark.mm"

MSHJelloView *homescreenJelloView = nil;
bool shouldUpdateHSColor = false;

%group MitsuhaHomescreen

%hook SBIconController

-(void)loadView{
    %orig;
    
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Homescreen"];
    if (!config.enabled) return;
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    config.waveOffset += height*(9/10) + 100;
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(-25, 0, self.view.bounds.size.width + 50, height) andConfig:config];
    homescreenJelloView = self.mitsuhaJelloView;
    [self.view addSubview:self.mitsuhaJelloView];
    [self.view sendSubviewToBack:self.mitsuhaJelloView];

    shouldUpdateHSColor = config.enableDynamicColor;
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.frame.size.height + self.mitsuhaJelloView.config.waveOffset);
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdDisconnect];
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%end

%end

bool moveIntoPanel = false;
int atIndexCC = 1;

%group MitsuhaVisualsNotification

%hook SBDashBoardMediaControlsViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Springboard"];
    if (!config.enabled) return;

    self.view.clipsToBounds = 1;

    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    [mcpvc.headerView.artworkView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andConfig:config];

    if (!moveIntoPanel) {
        [self.view addSubview:self.mitsuhaJelloView];
        [self.view sendSubviewToBack:self.mitsuhaJelloView];
    } else {
        NSLog(@"[MitsuhaXI] Move into panel!");
        [mcpvc.view insertSubview:self.mitsuhaJelloView atIndex:1];
    }
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"] && self.mitsuhaJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    [self.mitsuhaJelloView dynamicColor:mcpvc.headerView.artworkView.image];
    if (self.mitsuhaJelloView.config.enableAutoUIColor) {
        [self readjustUIColor:self.mitsuhaJelloView.calculatedColor];
    }

    if (homescreenJelloView && shouldUpdateHSColor) {
        [homescreenJelloView dynamicColor:mcpvc.headerView.artworkView.image];
    }
}

%new;
-(void)readjustUIColor:(UIColor*)currentColor{
    MediaControlsPanelViewController *mcpvc = (MediaControlsPanelViewController*)[self valueForKey:@"_mediaControlsPanelViewController"];
    MediaControlsContainerView *controlsView = mcpvc.parentContainerView.mediaControlsContainerView;
    if (isDark(currentColor)) {
        [controlsView setStyle:202024];
    } else {
        [controlsView setStyle:3];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    self.view.superview.layer.masksToBounds = TRUE;
    [self.mitsuhaJelloView reloadConfig];
    if (self.mitsuhaJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
    } else if (self.mitsuhaJelloView.config.enableAutoUIColor) {
        [self readjustUIColor:self.mitsuhaJelloView.config.waveColor];
    }
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView msdDisconnect];
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%end

%end

%group MitsuhaVisualsCC

%hook MediaControlsPanelViewController

-(void)viewDidLayoutSubviews{
    %orig;
    if (self.mitsuhaJelloView) return;

    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"CC"];
    if (config.enabled) {
        // Let's see if we're in CC - thanks to Maxwell Dausch (@M_Dausch on Twitter)
        bool isCC = false;
        UIResponder *nextResponder = self.view.nextResponder;
        while (nextResponder) {
            if ([NSStringFromClass([nextResponder class]) isEqualToString:@"CCUIContentModuleContainerViewController"]) {
                isCC = true;
                break;
            }
            nextResponder = nextResponder.nextResponder;
        }

        if (!isCC) return;
        self.view.clipsToBounds = 1;
        self.view.layer.cornerRadius = 20;
        self.view.layer.masksToBounds = TRUE;
        
        self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andConfig:config];
        [self.view insertSubview:self.mitsuhaJelloView atIndex:atIndexCC];
    }

    [self.headerView.artworkView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"image"]) {
    [self readjustWaveColor];
  }
}

%new;
-(void)readjustWaveColor{
    if (self.mitsuhaJelloView && self.mitsuhaJelloView.config.enableDynamicColor) {
        [self.mitsuhaJelloView dynamicColor:self.headerView.artworkView.image];
    }

    if (homescreenJelloView && shouldUpdateHSColor) {
        [homescreenJelloView dynamicColor:self.headerView.artworkView.image];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    if (!self.mitsuhaJelloView) return;
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
    [self.mitsuhaJelloView reloadConfig];
    [self readjustWaveColor];
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    if (!self.mitsuhaJelloView) return;
    [self.mitsuhaJelloView msdDisconnect];
}

%new
-(void)setMitsuhaJelloView:(MSHJelloView *)mitsuhaJelloView{
    objc_setAssociatedObject(self, @selector(mitsuhaJelloView), mitsuhaJelloView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(MSHJelloView *)mitsuhaJelloView{
    return objc_getAssociatedObject(self, @selector(mitsuhaJelloView));
}

%end

%end

%ctor{
    MSHJelloViewConfig *config_ls = [MSHJelloViewConfig loadConfigForApplication:@"Springboard"];
    MSHJelloViewConfig *config_cc = [MSHJelloViewConfig loadConfigForApplication:@"CC"];
    MSHJelloViewConfig *config_hs = [MSHJelloViewConfig loadConfigForApplication:@"Homescreen"];

    if(config_hs.enabled) {
        %init(MitsuhaHomescreen);
    }

    if(config_ls.enabled || config_cc.enabled){
        //Check if Artsy is installed
        bool artsyEnabled = false;
        bool artsyLsEnabled = false;
        bool artsyCcEnabled = false;
        bool artsyPresent = [[NSFileManager defaultManager] fileExistsAtPath: ArtsyTweakDylibFile] && [[NSFileManager defaultManager] fileExistsAtPath: ArtsyTweakPlistFile];

        if (artsyPresent) {
            NSLog(@"[MitsuhaXI] Artsy found");
            artsyEnabled = true; //it's enabled by default when Artsy is installed
            artsyLsEnabled = true;
            artsyCcEnabled = true;
            
            //Check if Artsy is enabled
            NSMutableDictionary *artsyPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:ArtsyPreferencesFile];
            if (artsyPrefs) {
                artsyEnabled = [([artsyPrefs objectForKey:@"enabled"] ?: @(YES)) boolValue];
                artsyLsEnabled = [([artsyPrefs objectForKey:@"lsEnabled"] ?: @(YES)) boolValue];
                artsyCcEnabled = [([artsyPrefs objectForKey:@"ccEnabled"] ?: @(YES)) boolValue];
            }
        }

        if (artsyEnabled) {
            if (artsyLsEnabled) {
                NSLog(@"[MitsuhaXI] Artsy lsEnabled = true");
                moveIntoPanel = true;
            }

            if (artsyCcEnabled) {
                atIndexCC = 2;
            }
        }

        if (config_ls.enabled) {
            %init(MitsuhaVisualsNotification);
        }
    }

    if (config_cc.enabled || config_hs.enabled) {
        %init(MitsuhaVisualsCC); // we need this for the dynamic color to work properly on the homescreen
    }
}
