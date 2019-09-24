#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import "UIImage+BlurAndDarken.h"

@interface NRDManager : NSObject

@property (nonatomic, retain) UIColor *mainColor;
@property (nonatomic, retain) UIColor *fallbackColor;
@property (nonatomic, retain) UIColor *legibilityColor;
@property (nonatomic, retain) UIColor *artworkBackgroundColor;
+(instancetype)sharedInstance;
-(id)init;

@end

@interface SBDashBoardAdjunctItemView : UIView

@property (nonatomic, retain) UIView *backgroundMaterialView;

@end

@interface SBDashBoardViewController : UIViewController

@property (nonatomic, retain) UIImageView *nrdArtworkView;

@end

@interface SBDashBoardNotificationAdjunctListViewController : UIViewController

-(BOOL)isShowingMediaControls;
-(BOOL)isPresentingContent;
-(id)init;
-(void)reloadColors;

@end

@interface SBApplication : NSObject

@property (nonatomic,readonly) NSString * bundleIdentifier;

@end

@interface SBMediaController : NSObject

@property (nonatomic,readonly) SBApplication * nowPlayingApplication;
@property (nonatomic, retain) NSData *nrdLastImageData;
-(id)_nowPlayingInfo;

@end

/* Media Control hell here */

@interface MPCMediaRemoteController : NSObject

-(void)sendCommand:(unsigned)arg1 options:(id)arg2 completion:(/*^block*/id)arg3 ;

@end

@interface MPButton : UIButton

@property (assign,nonatomic) UIEdgeInsets alignmentRectInsets;           //@synthesize alignmentRectInsets=_alignmentRectInsets - In the implementation block
@property (assign,nonatomic) UIEdgeInsets hitRectInsets;                 //@synthesize hitRectInsets=_hitRectInsets - In the implementation block
@property (assign,nonatomic) double holdDelayInterval;                   //@synthesize holdDelayInterval=_holdDelayInterval - In the implementation block
@property (getter=isHolding,nonatomic,readonly) bool holding; 
@property (assign,nonatomic) bool hitTestDebugEnabled;                   //@synthesize hitTestDebugEnabled=_hitTestDebugEnabled - In the implementation block
+(id)easyTouchButtonWithType:(long long)arg1 ;
+(UIEdgeInsets)easyTouchDefaultHitRectInsets;
+(double)easyTouchDefaultCharge;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(void)dealloc;
-(bool)pointInside:(CGPoint)arg1 withEvent:(id)arg2 ;
-(void)touchesEnded:(id)arg1 withEvent:(id)arg2 ;
-(void)touchesCancelled:(id)arg1 withEvent:(id)arg2 ;
-(UIEdgeInsets)alignmentRectInsets;
-(CGRect)hitRect;
-(void)setAlignmentRectInsets:(UIEdgeInsets)arg1 ;
-(void)cancelTrackingWithEvent:(id)arg1 ;
-(bool)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(bool)isHolding;
-(void)_handleTouchDown;
-(void)_handleTouchCancel;
-(void)_handleTouchUp;
-(void)_delayedTriggerHold;
-(double)holdDelayInterval;
-(void)setHitTestDebugEnabled:(bool)arg1 ;
-(void)setHoldDelayInterval:(double)arg1 ;
-(bool)hitTestDebugEnabled;
-(void)setHitRectInsets:(UIEdgeInsets)arg1 ;
-(UIEdgeInsets)hitRectInsets;
@end

@interface MPUMarqueeView : UIView <CAAnimationDelegate>

@property (nonatomic, assign) BOOL nrdEnabled;
@property (assign,nonatomic) double contentGap;                                        //@synthesize contentGap=_contentGap - In the implementation block
@property (assign,nonatomic) CGSize contentSize;                                       //@synthesize contentSize=_contentSize - In the implementation block
@property (nonatomic,readonly) UIView * contentView;                                   //@synthesize contentView=_contentView - In the implementation block
@property (assign,nonatomic) UIEdgeInsets fadeEdgeInsets;                              //@synthesize fadeEdgeInsets=_fadeEdgeInsets - In the implementation block
@property (assign,nonatomic) double marqueeDelay;                                      //@synthesize marqueeDelay=_marqueeDelay - In the implementation block
@property (assign,nonatomic) double marqueeScrollRate;                                 //@synthesize marqueeScrollRate=_marqueeScrollRate - In the implementation block
@property (assign,getter=isMarqueeEnabled,nonatomic) BOOL marqueeEnabled;              //@synthesize marqueeEnabled=_marqueeEnabled - In the implementation block
@property (nonatomic,readonly) NSArray * coordinatedMarqueeViews; 
@property (nonatomic,retain) UIView * viewForContentSize;                              //@synthesize viewForContentSize=_viewForContentSize - In the implementation block
@property (assign,nonatomic) long long animationDirection;                 
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setFrame:(CGRect)arg1 ;
-(CGSize)contentSize;
-(void)layoutSubviews;
-(UIView *)contentView;
-(void)setContentSize:(CGSize)arg1 ;
-(void)didMoveToWindow;
-(void)invalidateIntrinsicContentSize;
-(void)setBounds:(CGRect)arg1 ;
-(CGSize)intrinsicContentSize;
-(double)_duration;
-(void)animationDidStop:(id)arg1 finished:(BOOL)arg2 ;
-(id)viewForLastBaselineLayout;
-(void)setMarqueeEnabled:(BOOL)arg1 ;
-(id)viewForFirstBaselineLayout;
-(void)_createMarqueeAnimationIfNeeded;
-(void)_tearDownMarqueeAnimation;
-(void)_applyMarqueeFade;
-(void)setMarqueeEnabled:(BOOL)arg1 withOptions:(long long)arg2 ;
-(void)addCoordinatedMarqueeView:(id)arg1 ;
-(void)_createMarqueeAnimationIfNeededWithMaximumDuration:(double)arg1 beginTime:(double)arg2 ;
-(void)setContentGap:(double)arg1 ;
-(void)setMarqueeScrollRate:(double)arg1 ;
-(void)setViewForContentSize:(UIView *)arg1 ;
-(NSArray *)coordinatedMarqueeViews;
-(void)resetMarqueePosition;
-(double)contentGap;
-(UIEdgeInsets)fadeEdgeInsets;
-(void)setFadeEdgeInsets:(UIEdgeInsets)arg1 ;
-(double)marqueeScrollRate;
-(BOOL)isMarqueeEnabled;
-(UIView *)viewForContentSize;
-(double)marqueeDelay;
-(void)setMarqueeDelay:(double)arg1 ;
-(long long)animationDirection;
-(void)setAnimationDirection:(long long)arg1 ;
@end

@interface MPCPlayerCommandRequest : NSObject

@property (nonatomic,readonly) unsigned command;                                   //@synthesize command=_command - In the implementation block
@property (nonatomic,copy,readonly) NSDictionary * options;                        //@synthesize options=_options - In the implementation block
@property (nonatomic,copy) NSDictionary * userInitiatedOptions;                    //@synthesize userInitiatedOptions=_userInitiatedOptions - In the implementation block
@property (nonatomic,readonly) id controller;              //@synthesize controller=_controller - In the implementation block
@property (nonatomic,readonly) id playerPath;                         //@synthesize playerPath=_playerPath - In the implementation block
@property (nonatomic,copy) NSString * label;            
-(id)initWithMediaRemoteCommand:(unsigned)arg1 options:(id)arg2 controller:(id)arg3 ;
-(id)initWithMediaRemoteCommand:(unsigned)arg1 options:(id)arg2 response:(id)arg3 ;
-(id)initWithMediaRemoteCommand:(unsigned)arg1 options:(id)arg2 playerPath:(id)arg3 label:(id)arg4 ;

@end

@interface MediaControlsTransportButton : MPButton 

@property (nonatomic,retain) MPCPlayerCommandRequest * touchUpInsideCommandRequest; 
@property (assign,nonatomic) BOOL shouldPresentActionSheet;                                                          //@synthesize shouldPresentActionSheet=_shouldPresentActionSheet - In the implementation block
@property (getter=isPerformingHighlightAnimation,nonatomic,readonly) BOOL performingHighlightAnimation;              //@synthesize performingHighlightAnimation=_performingHighlightAnimation - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setHighlighted:(BOOL)arg1 ;
-(void)_layoutImageView;
-(BOOL)shouldPresentActionSheet;
-(void)setShouldPresentActionSheet:(BOOL)arg1 ;
-(void)beginHighlight;
-(void)endHighlight;
-(BOOL)isPerformingHighlightAnimation;

@end

@interface MPCPlayerResponseTracklist : NSObject

//@property (nonatomic,copy,readonly) MPSectionedCollection * items;                   //@synthesize items=_items - In the implementation block
@property (nonatomic,copy,readonly) NSIndexPath * playingItemIndexPath;              //@synthesize playingItemIndexPath=_playingItemIndexPath - In the implementation block
@property (nonatomic,readonly) long long playingItemGlobalIndex;                     //@synthesize playingItemGlobalIndex=_playingItemGlobalIndex - In the implementation block
@property (nonatomic,readonly) long long globalItemCount;                            //@synthesize globalItemCount=_globalItemCount - In the implementation block
@property (nonatomic,readonly) long long lastChangeDirection;                        //@synthesize lastChangeDirection=_lastChangeDirection - In the implementation block
@property (nonatomic,readonly) long long upNextItemCount;                            //@synthesize upNextItemCount=_upNextItemCount - In the implementation block
@property (nonatomic,readonly) long long repeatType;                                 //@synthesize repeatType=_repeatType - In the implementation block
@property (nonatomic,readonly) long long shuffleType;                                //@synthesize shuffleType=_shuffleType - In the implementation block
-(id)initWithResponse:(id)arg1 ;
//-(MPSectionedCollection *)items;
-(long long)repeatType;
-(long long)shuffleType;
-(long long)upNextItemCount;
-(id)resetCommand;
-(id)insertCommand;
-(id)reorderCommand;
-(id)repeatCommand;
-(id)shuffleCommand;
-(id)changeItemCommand;
-(long long)lastChangeDirection;
-(NSIndexPath *)playingItemIndexPath;
-(long long)playingItemGlobalIndex;
-(long long)globalItemCount;

@end

@interface MPResponse : NSObject

@property (nonatomic,copy) NSArray * middleware;                       //@synthesize middleware=_middleware - In the implementation block
@property (nonatomic,readonly) id builder;                             //@synthesize builder=_builder - In the implementation block
@property (nonatomic,copy,readonly) id request;                        //@synthesize request=_request - In the implementation block
@property (getter=isValid,nonatomic,readonly) BOOL valid;              //@synthesize valid=_valid - In the implementation block
+(id)builderProtocol;
-(void)invalidate;
-(id)description;
-(BOOL)isValid;
-(id)request;
-(id)copyWithZone:(NSZone*)arg1 ;
-(id)initWithRequest:(id)arg1 middleware:(id)arg2 ;
-(NSArray *)middleware;
-(id)chain;
-(void)setMiddleware:(NSArray *)arg1 ;
-(id)builder;
@end

@interface MPCPlayerResponse : MPResponse

@property (nonatomic,readonly) MPCMediaRemoteController * controller;               //@synthesize controller=_controller - In the implementation block
@property (nonatomic,readonly) MPCPlayerResponseTracklist * tracklist;              //@synthesize tracklist=_tracklist - In the implementation block

@end

@interface MediaControlsHeaderView : UIView

@property (nonatomic,retain) UIView * artworkBackground;   
@property (nonatomic,retain) UIImageView * artworkView;                                            //@synthesize artworkView=_artworkView - In the implementation block
@property (nonatomic,retain) UIImageView * placeholderArtworkView;                                 //@synthesize placeholderArtworkView=_placeholderArtworkView - In the implementation block
@property (assign,nonatomic) CGSize artworkSize;                                                   //@synthesize artworkSize=_artworkSize - In the implementation block
@property (nonatomic,retain) UIView * artworkBackgroundView;                                       //@synthesize artworkBackgroundView=_artworkBackgroundView - In the implementation block
@property (nonatomic,retain) UIView * shadow;                                                      //@synthesize shadow=_shadow - In the implementation block
//@property (nonatomic,retain) MPUMarqueeView * titleMarqueeView;                                    //@synthesize titleMarqueeView=_titleMarqueeView - In the implementation block
@property (nonatomic,retain) UILabel * titleLabel;                                                 //@synthesize titleLabel=_titleLabel - In the implementation block
@property (nonatomic,retain) UILabel * routeLabel;     
@property (nonatomic,retain) MPUMarqueeView * primaryMarqueeView;                                  //@synthesize primaryMarqueeView=_primaryMarqueeView - In the implementation block
@property (nonatomic,retain) UILabel * primaryLabel;                                               //@synthesize primaryLabel=_primaryLabel - In the implementation block
@property (nonatomic,retain) MPUMarqueeView * secondaryMarqueeView;                                //@synthesize secondaryMarqueeView=_secondaryMarqueeView - In the implementation block
@property (nonatomic,retain) UILabel * secondaryLabel;                                             //@synthesize secondaryLabel=_secondaryLabel - In the implementation block
@property (nonatomic,retain) UIView * buttonBackground;                                            //@synthesize buttonBackground=_buttonBackground - In the implementation block
@property (assign,nonatomic) BOOL shouldUseOverrideSize;                                           //@synthesize shouldUseOverrideSize=_shouldUseOverrideSize - In the implementation block
@property (assign,nonatomic) BOOL shouldUsePlaceholderArtwork;                                     //@synthesize shouldUsePlaceholderArtwork=_shouldUsePlaceholderArtwork - In the implementation block
@property (assign,nonatomic) BOOL shouldEnableMarquee;                                             //@synthesize shouldEnableMarquee=_shouldEnableMarquee - In the implementation block
@property (assign,getter=isTransitioning,nonatomic) BOOL transitioning;                            //@synthesize transitioning=_transitioning - In the implementation block
@property (assign,getter=isShowingRoutingPicker,nonatomic) BOOL showingRoutingPicker;              //@synthesize showingRoutingPicker=_showingRoutingPicker - In the implementation block
@property (assign,nonatomic) BOOL onlyShowsRoutingPicker;                                          //@synthesize onlyShowsRoutingPicker=_onlyShowsRoutingPicker - In the implementation block
@property (assign,nonatomic) long long style;                                                      //@synthesize style=_style - In the implementation block
@property (nonatomic,retain) NSString * titleString;                                               //@synthesize titleString=_titleString - In the implementation block
@property (nonatomic,retain) NSString * primaryString;                                             //@synthesize primaryString=_primaryString - In the implementation block
@property (nonatomic,retain) NSString * secondaryString;                                           //@synthesize secondaryString=_secondaryString - In the implementation block
@property (nonatomic,retain) MPButton * routingButton;                                             //@synthesize routingButton=_routingButton - In the implementation block
@property (nonatomic,retain) MPButton * doneButton;                                                //@synthesize doneButton=_doneButton - In the implementation block
@property (nonatomic,retain) MPButton * playPauseButton;                                           //@synthesize playPauseButton=_playPauseButton - In the implementation block
@property (nonatomic,retain) UIButton * launchNowPlayingAppButton;                                 //@synthesize launchNowPlayingAppButton=_launchNowPlayingAppButton - In the implementation block
@property (nonatomic,retain) NSString * mediaSourceBundleID;                                       //@synthesize mediaSourceBundleID=_mediaSourceBundleID - In the implementation block
@property (assign,getter=isHeaderViewOnScreen,nonatomic) BOOL headerViewOnScreen;                  //@synthesize headerViewOnScreen=_headerViewOnScreen - In the implementation block
@property (assign,nonatomic) CGSize overrideSize;                                                  //@synthesize overrideSize=_overrideSize - In the implementation block
-(NSString *)titleString;
-(void)setTitleString:(NSString *)arg1 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(void)dealloc;
-(void)didMoveToWindow;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(UILabel *)titleLabel;
-(void)_updateStyle;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(void)setOverrideSize:(CGSize)arg1 ;
-(CGSize)overrideSize;
-(BOOL)isTransitioning;
-(void)setDoneButton:(MPButton *)arg1 ;
-(MPButton *)doneButton;
-(UILabel *)secondaryLabel;
-(void)setSecondaryLabel:(UILabel *)arg1 ;
-(void)setTitleLabel:(UILabel *)arg1 ;
-(UIView *)shadow;
-(void)setShadow:(UIView *)arg1 ;
-(void)setTransitioning:(BOOL)arg1 ;
-(CGSize)artworkSize;
-(UILabel *)primaryLabel;
-(void)setPrimaryLabel:(UILabel *)arg1 ;
-(void)setPrimaryString:(NSString *)arg1 ;
-(void)setSecondaryString:(NSString *)arg1 ;
-(NSString *)primaryString;
-(NSString *)secondaryString;
-(void)setArtworkSize:(CGSize)arg1 ;
-(void)_handleContentSizeCategoryDidChangeNotification:(id)arg1 ;
-(BOOL)isShowingRoutingPicker;
-(void)setShowingRoutingPicker:(BOOL)arg1 ;
-(MPButton *)routingButton;
-(UIButton *)launchNowPlayingAppButton;
-(void)updatePlaceholderArtwork;
-(void)setHeaderViewOnScreen:(BOOL)arg1 ;
-(void)setMediaSourceBundleID:(NSString *)arg1 ;
-(NSString *)mediaSourceBundleID;
-(BOOL)onlyShowsRoutingPicker;
-(void)clearOverrideSize;
-(void)setOnlyShowsRoutingPicker:(BOOL)arg1 ;
-(UIView *)artworkBackgroundView;
-(UIImageView *)placeholderArtworkView;
-(MPUMarqueeView *)titleMarqueeView;
-(MPUMarqueeView *)primaryMarqueeView;
-(MPUMarqueeView *)secondaryMarqueeView;
-(UIView *)buttonBackground;
-(BOOL)shouldUseOverrideSize;
-(CGSize)layoutTextInAvailableBounds:(CGRect)arg1 setFrames:(BOOL)arg2 ;
-(BOOL)shouldEnableMarquee;
-(BOOL)shouldUsePlaceholderArtwork;
-(void)setShouldEnableMarquee:(BOOL)arg1 ;
-(void)_updateRTL;
-(void)setShouldUseOverrideSize:(BOOL)arg1 ;
-(void)setShouldUsePlaceholderArtwork:(BOOL)arg1 ;
-(void)setRoutingButton:(MPButton *)arg1 ;
-(void)setLaunchNowPlayingAppButton:(UIButton *)arg1 ;
-(BOOL)isHeaderViewOnScreen;
-(void)setPlaceholderArtworkView:(UIImageView *)arg1 ;
-(void)setArtworkBackgroundView:(UIView *)arg1 ;
-(void)setTitleMarqueeView:(MPUMarqueeView *)arg1 ;
-(void)setPrimaryMarqueeView:(MPUMarqueeView *)arg1 ;
-(void)setSecondaryMarqueeView:(MPUMarqueeView *)arg1 ;
-(void)setButtonBackground:(UIView *)arg1 ;
-(MPButton *)playPauseButton;
-(void)setPlayPauseButton:(MPButton *)arg1 ;
-(void)setArtworkView:(UIImageView *)arg1 ;
-(UIImageView *)artworkView;

@property (nonatomic, assign) BOOL nrdEnabled;

-(void)nrdUpdate;
-(void)nrdForceViewToBeWhereItShouldBe:(UIView *)view supersuperview:(UIView *)supersuperview;

@end

@interface MediaControlsRoutingCornerView : UIView

@property (assign,getter=routesAreAvailable,nonatomic) BOOL routesAvailable;              //@synthesize routesAvailable=_routesAvailable - In the implementation block
@property (assign,getter=isRouting,nonatomic) BOOL routing;                               //@synthesize routing=_routing - In the implementation block
@property (assign,nonatomic) BOOL shouldPauseAnimations;                                  //@synthesize shouldPauseAnimations=_shouldPauseAnimations - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setRouting:(BOOL)arg1 ;
-(void)_updateGlyph;
-(BOOL)routesAreAvailable;
-(BOOL)isRouting;
-(BOOL)shouldPauseAnimations;
-(void)setRoutesAvailable:(BOOL)arg1 ;
-(void)setShouldPauseAnimations:(BOOL)arg1 ;
@end

@interface MediaControlsTransportStackView : UIView

@property (nonatomic,retain) MPCPlayerResponse* response;                                                  //@synthesize response=_response - In the implementation block
@property (nonatomic,retain) MediaControlsTransportButton * middleButton;                                      //@synthesize middleButton=_middleButton - In the implementation block
@property (nonatomic,retain) MediaControlsTransportButton * rightButton;                                       //@synthesize rightButton=_rightButton - In the implementation block
@property (nonatomic,retain) NSBundle * mediaControlsBundle;                                                   //@synthesize mediaControlsBundle=_mediaControlsBundle - In the implementation block
@property (nonatomic,retain) UIColor * tintColorForCurrentStyle;                                               //@synthesize tintColorForCurrentStyle=_tintColorForCurrentStyle - In the implementation block
@property (assign,nonatomic) long long mediaControlsPlayerState;                                               //@synthesize mediaControlsPlayerState=_mediaControlsPlayerState - In the implementation block
@property (assign,nonatomic) long long style;                                                                  //@synthesize style=_style - In the implementation block
@property (assign,getter=isEmpty,nonatomic) BOOL empty;                                                        //@synthesize empty=_empty - In the implementation block
@property (nonatomic,retain) MediaControlsTransportButton * leftButton;                                        //@synthesize leftButton=_leftButton - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(BOOL)isEmpty;
-(void)buttonHoldReleased:(id)arg1 ;
-(void)setEmpty:(BOOL)arg1 ;
-(MediaControlsTransportButton *)leftButton;
-(MediaControlsTransportButton *)rightButton;
-(void)setLeftButton:(MediaControlsTransportButton *)arg1 ;
-(void)setRightButton:(MediaControlsTransportButton *)arg1 ;
-(NSBundle *)mediaControlsBundle;
-(void)setMediaControlsPlayerState:(long long)arg1 ;
-(long long)mediaControlsPlayerState;
-(MediaControlsTransportButton *)middleButton;
-(void)touchUpInsideLeftButton:(id)arg1 ;
-(void)touchUpInsideMiddleButton:(id)arg1 ;
-(void)touchUpInsideRightButton:(id)arg1 ;
-(void)buttonHoldBegan:(id)arg1 ;
-(void)_updateButtonBlendMode:(id)arg1 ;
-(void)_updateButtonImage:(id)arg1 button:(id)arg2 ;
-(void)setMiddleButton:(MediaControlsTransportButton *)arg1 ;
-(void)setMediaControlsBundle:(NSBundle *)arg1 ;
-(UIColor *)tintColorForCurrentStyle;
-(void)setTintColorForCurrentStyle:(UIColor *)arg1 ;

@property (nonatomic, retain) MediaControlsTransportButton * nrdLeftButton;
@property (nonatomic, retain) MediaControlsTransportButton * nrdRightButton;
@property (nonatomic, retain) UIView * nrdCircleView;
@property (nonatomic, assign) BOOL nrdEnabled;

-(void)nrdUpdate;

@end

@interface MediaControlsTimeControl : UIControl <UIGestureRecognizerDelegate>

@property (nonatomic,retain) UIView * elapsedTrack;                                              //@synthesize elapsedTrack=_elapsedTrack - In the implementation block
@property (nonatomic,retain) UIView * remainingTrack;                                            //@synthesize remainingTrack=_remainingTrack - In the implementation block
@property (nonatomic,retain) UIView * knobView;                                                  //@synthesize knobView=_knobView - In the implementation block
@property (nonatomic,retain) UILabel * elapsedTimeLabel;                                         //@synthesize elapsedTimeLabel=_elapsedTimeLabel - In the implementation block
@property (nonatomic,retain) UILabel * remainingTimeLabel;                                       //@synthesize remainingTimeLabel=_remainingTimeLabel - In the implementation block
@property (nonatomic,retain) UILabel * liveLabel;                                                //@synthesize liveLabel=_liveLabel - In the implementation block
@property (nonatomic,retain) UIImageView * liveBackground;                                       //@synthesize liveBackground=_liveBackground - In the implementation block
@property (nonatomic,retain) UILayoutGuide * trackLayoutGuide;                                   //@synthesize trackLayoutGuide=_trackLayoutGuide - In the implementation block
@property (assign,nonatomic) double sliderValue;                                                 //@synthesize sliderValue=_sliderValue - In the implementation block
@property (assign,getter=isCurrentlyTracking,nonatomic) BOOL currentlyTracking;                  //@synthesize currentlyTracking=_currentlyTracking - In the implementation block
@property (assign,getter=isLive,nonatomic) BOOL live;                                            //@synthesize live=_live - In the implementation block
@property (assign,getter=isTransitioning,nonatomic) BOOL transitioning;                          //@synthesize transitioning=_transitioning - In the implementation block
@property (assign,getter=isEmpty,nonatomic) BOOL empty;                                          //@synthesize empty=_empty - In the implementation block
@property (assign,nonatomic) long long style;
@property (assign,getter=isTimeControlOnScreen,nonatomic) BOOL timeControlOnScreen;              //@synthesize timeControlOnScreen=_timeControlOnScreen - In the implementation block
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(BOOL)isLive;
-(void)setLive:(BOOL)arg1 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(void)dealloc;
-(BOOL)pointInside:(CGPoint)arg1 withEvent:(id)arg2 ;
-(void)didMoveToWindow;
-(BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 ;
-(void)_updateStyle;
-(long long)style;
-(void)setEnabled:(BOOL)arg1 ;
-(void)setStyle:(long long)arg1 ;
-(BOOL)isEmpty;
-(void)viewDidMoveToSuperview;
-(BOOL)isTransitioning;
-(void)cancelTrackingWithEvent:(id)arg1 ;
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(BOOL)continueTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(void)_displayLinkTick:(id)arg1 ;
-(void)setTransitioning:(BOOL)arg1 ;
-(UILayoutGuide *)trackLayoutGuide;
-(UILabel *)elapsedTimeLabel;
-(void)setEmpty:(BOOL)arg1 ;
-(void)setElapsedTimeLabel:(UILabel *)arg1 ;
-(void)setRemainingTimeLabel:(UILabel *)arg1 ;
-(UILabel *)remainingTimeLabel;
-(void)setKnobView:(UIView *)arg1 ;
-(UIView *)knobView;
-(double)sliderValue;
-(void)setSliderValue:(double)arg1 ;
-(UIView *)elapsedTrack;
-(UIView *)remainingTrack;
-(UIImageView *)liveBackground;
-(UILabel *)liveLabel;
-(void)_updateTimeControl;
-(void)setTimeControlOnScreen:(BOOL)arg1 ;
-(void)_updateSliderPosition;
-(void)_updateLabels:(double)arg1 withRemainingDuration:(double)arg2 ;
-(void)_updateDisplayLinkPause;
-(void)updateLabelAvoidance;
-(BOOL)isCurrentlyTracking;
-(BOOL)isTimeControlOnScreen;
-(void)setElapsedTrack:(UIView *)arg1 ;
-(void)setRemainingTrack:(UIView *)arg1 ;
-(void)setLiveLabel:(UILabel *)arg1 ;
-(void)setLiveBackground:(UIImageView *)arg1 ;
-(void)setTrackLayoutGuide:(UILayoutGuide *)arg1 ;
-(void)setCurrentlyTracking:(BOOL)arg1 ;

@property (nonatomic, assign) BOOL nrdEnabled;

-(void)nrdUpdate;

@end

@interface MediaControlsContainerView : UIView

@property (nonatomic,retain) UIVisualEffectView * primaryVisualEffectView;                                   //@synthesize primaryVisualEffectView=_primaryVisualEffectView - In the implementation block
@property (assign,nonatomic) long long mediaControlsPlayerState;                                             //@synthesize mediaControlsPlayerState=_mediaControlsPlayerState - In the implementation block
@property (assign,nonatomic) long long style;                                                                //@synthesize style=_style - In the implementation block
@property (assign,getter=isEmpty,nonatomic) BOOL empty;                                                      //@synthesize empty=_empty - In the implementation block
@property (assign,getter=isTimeControlOnScreen,nonatomic) BOOL timeControlOnScreen; 
@property (nonatomic,retain) MediaControlsTransportStackView * mediaControlsTransportStackView;              //@synthesize mediaControlsTransportStackView=_mediaControlsTransportStackView - In the implementation block
@property (nonatomic,retain) MediaControlsTimeControl * mediaControlsTimeControl;                            //@synthesize mediaControlsTimeControl=_mediaControlsTimeControl - In the implementation block
@property (nonatomic,retain) MediaControlsTimeControl * timeControl; 
@property (nonatomic,retain) MediaControlsTransportStackView * transportStackView;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(BOOL)isEmpty;
-(UIVisualEffectView *)primaryVisualEffectView;
-(void)setPrimaryVisualEffectView:(UIVisualEffectView *)arg1 ;
-(void)setEmpty:(BOOL)arg1 ;
-(void)setTimeControlOnScreen:(BOOL)arg1 ;
-(BOOL)isTimeControlOnScreen;
-(MediaControlsTransportStackView *)mediaControlsTransportStackView;
-(void)setRatingActionSheetDelegate:(id)arg1 ;
-(MediaControlsTimeControl *)mediaControlsTimeControl;
-(void)setMediaControlsPlayerState:(long long)arg1 ;
-(long long)mediaControlsPlayerState;
-(void)setMediaControlsTransportStackView:(MediaControlsTransportStackView *)arg1 ;
-(void)setMediaControlsTimeControl:(MediaControlsTimeControl *)arg1 ;

@property (nonatomic, assign) BOOL nrdEnabled;

-(void)nrdUpdate;

@end

@interface MediaControlsParentContainerView : UIView

@property (nonatomic,retain) UIView * mediaControlsRoutingPickerView;                              //@synthesize mediaControlsRoutingPickerView=_mediaControlsRoutingPickerView - In the implementation block
@property (assign,nonatomic) long long routingViewControllerAnimationCount;                        //@synthesize routingViewControllerAnimationCount=_routingViewControllerAnimationCount - In the implementation block
@property (assign,nonatomic) long long style;                                                      //@synthesize style=_style - In the implementation block
@property (assign,getter=isShowingRoutingPicker,nonatomic) BOOL showingRoutingPicker;              //@synthesize showingRoutingPicker=_showingRoutingPicker - In the implementation block
@property (nonatomic,retain) MediaControlsContainerView * mediaControlsContainerView;              //@synthesize mediaControlsContainerView=_mediaControlsContainerView - In the implementation block
@property (nonatomic,retain) MediaControlsContainerView * containerView;   
@property (assign,getter=isEmpty,nonatomic) BOOL empty;                                            //@synthesize empty=_empty - In the implementation block
@property (nonatomic,retain) UIView * routingView;                                                 //@synthesize routingView=_routingView - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(BOOL)isEmpty;
-(void)setEmpty:(BOOL)arg1 ;
-(MediaControlsContainerView *)mediaControlsContainerView;
-(UIView *)mediaControlsRoutingPickerView;
-(void)_updateRoutingPickerVisibility;
-(BOOL)isShowingRoutingPicker;
-(void)setShowingRoutingPicker:(BOOL)arg1 ;
-(void)setRoutingView:(UIView *)arg1 ;
-(void)setMediaControlsContainerView:(MediaControlsContainerView *)arg1 ;
-(UIView *)routingView;
-(void)setMediaControlsRoutingPickerView:(UIView *)arg1 ;
-(long long)routingViewControllerAnimationCount;
-(void)setRoutingViewControllerAnimationCount:(long long)arg1 ;
@end

@interface MPVolumeSlider : UISlider

@property (nonatomic, assign) BOOL nrdEnabled;
@property (nonatomic,readonly) UIView* thumbView;

-(UIImageView *)_minTrackView;
-(UIImageView *)_maxTrackView;
-(UIImageView *)_minValueView;
-(UIImageView *)_maxValueView;
-(void)_resetThumbImageForState:(unsigned long long)arg1 ;

@end

@interface MediaControlsVolumeContainerView : UIView

@property (nonatomic,retain) MPVolumeSlider * volumeSlider;                          //@synthesize volumeSlider=_volumeSlider - In the implementation block
@property (assign,getter=isTransitioning,nonatomic) BOOL transitioning;              //@synthesize transitioning=_transitioning - In the implementation block
@property (assign,getter=isOnScreen,nonatomic) BOOL onScreen;                        //@synthesize onScreen=_onScreen - In the implementation block
@property (assign,nonatomic) long long style;          
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 ;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(BOOL)isTransitioning;
-(BOOL)isOnScreen;
-(void)setTransitioning:(BOOL)arg1 ;
-(MPVolumeSlider *)volumeSlider;
-(void)setOnScreen:(BOOL)arg1 ;
-(void)setVolumeSlider:(MPVolumeSlider *)arg1 ;

@property (nonatomic, assign) BOOL nrdEnabled;

-(void)nrdUpdate;

@end

@interface PLPlatterView : UIView

@property (nonatomic,readonly) UIView * backgroundMaterialView; 
@property (nonatomic,readonly) UIView * mainOverlayView; 

@end

@interface MediaControlsEndpointController : NSObject

@property (nonatomic,readonly) MPCPlayerResponse * response; 

@end

@interface UniversalNRDController : UIViewController

@property (nonatomic,retain) MPCPlayerResponse * response; 
@property (nonatomic,retain) MediaControlsEndpointController * endpointController;
@property (assign,nonatomic) long long style;                                                              //@synthesize style=_style - In the implementation block
@property (assign,nonatomic) long long mediaControlsPlayerState;                                           //@synthesize mediaControlsPlayerState=_mediaControlsPlayerState - In the implementation block
@property (assign,getter=isTransitioning,nonatomic) BOOL transitioning;                                    //@synthesize transitioning=_transitioning - In the implementation block
@property (nonatomic,retain) MediaControlsHeaderView * headerView;                                         //@synthesize headerView=_headerView - In the implementation block
@property (nonatomic,retain) MediaControlsHeaderView * nowPlayingHeaderView; 
@property (nonatomic,retain) MediaControlsRoutingCornerView * routingCornerView;                           //@synthesize routingCornerView=_routingCornerView - In the implementation block
@property (nonatomic,retain) MediaControlsParentContainerView * parentContainerView;                       //@synthesize parentContainerView=_parentContainerView - In the implementation block
@property (nonatomic,retain) MediaControlsVolumeContainerView * volumeContainerView;                       //@synthesize volumeContainerView=_volumeContainerView - In the implementation block
@property (nonatomic,retain) UIView * topDividerView;                                                      //@synthesize topDividerView=_topDividerView - In the implementation block
@property (nonatomic,retain) UIView * bottomDividerView;                                                   //@synthesize bottomDividerView=_bottomDividerView - In the implementation block
@property (assign,getter=isDismissing,nonatomic) BOOL dismissing;                                          //@synthesize dismissing=_dismissing - In the implementation block
@property (nonatomic,retain) NSMutableArray * secondaryStringComponents;                                   //@synthesize secondaryStringComponents=_secondaryStringComponents - In the implementation block
@property (assign,nonatomic) BOOL coverSheetRoutingViewControllerShouldBePresented;                        //@synthesize coverSheetRoutingViewControllerShouldBePresented=_coverSheetRoutingViewControllerShouldBePresented - In the implementation block
@property (assign,getter=isOnScreen,nonatomic) BOOL onScreen;                                              //@synthesize onScreen=_onScreen - In the implementation block
@property (assign,getter=isShowingRoutingPicker,nonatomic) BOOL showingRoutingPicker;                      //@synthesize showingRoutingPicker=_showingRoutingPicker - In the implementation block
@property (assign,nonatomic) BOOL onlyShowsRoutingPicker;                                                  //@synthesize onlyShowsRoutingPicker=_onlyShowsRoutingPicker - In the implementation block
@property (nonatomic,copy) id launchNowPlayingAppBlock;                                                    //@synthesize launchNowPlayingAppBlock=_launchNowPlayingAppBlock - In the implementation block
@property (nonatomic,copy) id routingCornerViewTappedBlock;                                    
@property (nonatomic,readonly) double preferredExpandedContentHeight; 
@property (nonatomic,readonly) double preferredExpandedContentWidth; 
@property (nonatomic,readonly) BOOL providesOwnPlatter; 
@property (nonatomic,retain) UIView * backgroundView;
+(id)panelViewControllerForCoverSheet;
-(void)_updateStyle;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(id)initWithNibName:(id)arg1 bundle:(id)arg2 ;
-(void)viewDidLayoutSubviews;
-(void)setBackgroundView:(UIView *)arg1 ;
-(UIView *)backgroundView;
-(BOOL)isTransitioning;
-(void)viewDidLoad;
-(void)viewWillAppear:(BOOL)arg1 ;
-(void)viewDidAppear:(BOOL)arg1 ;
-(void)viewWillDisappear:(BOOL)arg1 ;
-(void)viewDidDisappear:(BOOL)arg1 ;
-(MediaControlsHeaderView *)headerView;
-(void)setHeaderView:(MediaControlsHeaderView *)arg1 ;
-(BOOL)isOnScreen;
-(void)setTransitioning:(BOOL)arg1 ;
-(void)mediaControlsViewControllerDidReceiveInteraction:(id)arg1 ;
-(void)routingControllerAvailableRoutesDidChange:(id)arg1 ;
-(void)routingController:(id)arg1 pickedRouteDidChange:(id)arg2 ;
-(void)routingViewController:(id)arg1 willDisplayCell:(id)arg2 ;
-(void)controller:(id)arg1 defersResponseReplacement:(/*^block*/id)arg2 ;
-(void)setOnScreen:(BOOL)arg1 ;
-(void)setDismissing:(BOOL)arg1 ;
-(BOOL)isDismissing;
-(BOOL)isShowingRoutingPicker;
-(void)setShowingRoutingPicker:(BOOL)arg1 ;
-(void)setRoutingView:(id)arg1 ;
-(UIView *)bottomDividerView;
-(void)headerViewButtonPressed:(id)arg1 ;
-(void)headerViewLaunchNowPlayingAppButtonPressed:(id)arg1 ;
-(MediaControlsParentContainerView *)parentContainerView;
-(void)_updateRoutingState;
-(MediaControlsRoutingCornerView *)routingCornerView;
-(void)setLaunchNowPlayingAppBlock:(id)arg1 ;
-(MediaControlsVolumeContainerView *)volumeContainerView;
-(void)_routingCornerViewReceivedTap:(id)arg1 ;
-(void)_mediaControlsPanelViewControllerReceivedInteraction:(id)arg1 ;
-(void)_dismissRoutingViewControllerFromCoverSheetIfNeeded;
-(void)_updateSecondaryStringFormat;
-(void)_updateOnScreenForStyle:(long long)arg1 ;
-(void)setMediaControlsPlayerState:(long long)arg1 ;
-(void)_updatePickedRoute:(id)arg1 ;
-(void)_updateControlCenterMetadata:(id)arg1 ;
-(NSMutableArray *)secondaryStringComponents;
-(BOOL)onlyShowsRoutingPicker;
-(void)_presentRoutingViewControllerFromCoverSheet;
-(void)setCoverSheetRoutingViewControllerShouldBePresented:(BOOL)arg1 ;
-(BOOL)coverSheetRoutingViewControllerShouldBePresented;
-(void)setOnlyShowsRoutingPicker:(BOOL)arg1 ;
-(void)presentRatingActionSheet:(id)arg1 ;
-(UIEdgeInsets)contentInsetsForRoutingViewController:(id)arg1 ;
-(void)willTransitionToSize:(CGSize)arg1 withCoordinator:(id)arg2 ;
-(void)setRoutingCornerViewTappedBlock:(id)arg1 ;
-(long long)mediaControlsPlayerState;
-(void)setRoutingCornerView:(MediaControlsRoutingCornerView *)arg1 ;
-(void)setParentContainerView:(MediaControlsParentContainerView *)arg1 ;
-(void)setVolumeContainerView:(MediaControlsVolumeContainerView *)arg1 ;
-(void)setBottomDividerView:(UIView *)arg1 ;
-(void)setSecondaryStringComponents:(NSMutableArray *)arg1 ;
-(id)launchNowPlayingAppBlock;
-(id)routingCornerViewTappedBlock;
-(void)setTopDividerView:(UIView *)arg1 ;
-(UIView *)topDividerView;

@property (nonatomic, assign) BOOL nrdEnabled;

-(void)nrdUpdate;

@end

@interface MRPlatterViewController : UniversalNRDController

@end

@interface MediaControlsPanelViewController : UniversalNRDController

@end

@interface _UILegibilitySettings : NSObject

@property (nonatomic,retain) UIColor * primaryColor;

@end

@interface SBUILegibilityLabel : UIView

@property (nonatomic,retain) _UILegibilitySettings * legibilitySettings; 
-(void)_updateLegibilityView;
-(void)_updateLabelForLegibilitySettings;

@end

@interface SBFLockScreenDateView : UIView

-(id)initWithFrame:(CGRect)arg1 ;
-(void)nrdUpdate;

@end