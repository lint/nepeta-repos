#import "Tweak.h"

%group MitsuhaVisuals

%hook PlayerArtworkView

-(void)layoutSubviews{
    %orig;
    if (!self.superview) return;
    if (!self.superview.nextResponder) return;
    if (![NSStringFromClass([self.superview.nextResponder class]) isEqualToString:@"TrackPlayerViewController"]) return;

    MSHJelloView *mshJelloView = ((TrackPlayerViewController *)self.superview.nextResponder).mitsuhaJelloView;
    if (mshJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
    }

    [self addObserver:self forKeyPath:@"artworkImage" options:NSKeyValueObservingOptionNew context:NULL];
}

%new;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    MSHJelloView *mshJelloView = ((TrackPlayerViewController *)self.superview.nextResponder).mitsuhaJelloView;
    if ([keyPath isEqualToString:@"artworkImage"] && mshJelloView.config.enableDynamicColor) {
        [self readjustWaveColor];
    }
}

%new;
-(void)readjustWaveColor{
    MSHJelloView *mshJelloView = ((TrackPlayerViewController *)self.superview.nextResponder).mitsuhaJelloView;
    [mshJelloView dynamicColor:self.artworkImage];
}
%end

%hook TrackPlayerViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Soundcloud"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    if (!self.mitsuhaJelloView) self.mitsuhaJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
    [self.view insertSubview:self.mitsuhaJelloView atIndex:2];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [self.mitsuhaJelloView reloadConfig];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.mitsuhaJelloView.frame = CGRectMake(0, self.mitsuhaJelloView.config.waveOffset, self.view.bounds.size.width, height);
    [self.mitsuhaJelloView msdConnect];
    self.mitsuhaJelloView.center = CGPointMake(self.mitsuhaJelloView.center.x, self.mitsuhaJelloView.config.waveOffset);
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    //[self.mitsuhaJelloView msdDisconnect];
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
    if([MSHJelloViewConfig loadConfigForApplication:@"Soundcloud"].enabled){
        %init(MitsuhaVisuals);
    }
}
