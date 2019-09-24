#import "Tweak.h"

%group MitsuhaVisuals

MSHJelloView *mshJelloView = NULL;

%hook DeezerIllustrationView

-(void)layoutSubviews{
    %orig;

    if (mshJelloView != NULL && mshJelloView.config.enableDynamicColor) {
        [mshJelloView dynamicColor:((DeezerIllustrationView*)self).image];
    }
}
%end

%hook DZRPassThroughView
-(void)layoutSubviews{
    %orig;
    [self insertSubview:mshJelloView atIndex:1];
}
%end

%hook DZRPlayerViewController

-(void)loadView{
    %orig;
    MSHJelloViewConfig *config = [MSHJelloViewConfig loadConfigForApplication:@"Deezer"];
    if (!config.enabled) return;

    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.clipsToBounds = 1;
    
    mshJelloView = [[MSHJelloView alloc] initWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, height) andConfig:config];
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [mshJelloView reloadConfig];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    mshJelloView.frame = CGRectMake(0, mshJelloView.config.waveOffset, self.view.bounds.size.width, height);
    [mshJelloView msdConnect];
    mshJelloView.center = CGPointMake(mshJelloView.center.x, mshJelloView.config.waveOffset);
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [mshJelloView msdDisconnect];
}

%end

%end

%ctor{
    if([MSHJelloViewConfig loadConfigForApplication:@"Deezer"].enabled){
        %init(MitsuhaVisuals,
            DeezerIllustrationView = NSClassFromString(@"Deezer.IllustrationView"));
    }
}
