#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <Cephei/HBPreferences.h>

@interface NTFConfig : NSObject

@property (nonatomic,assign) bool enabled;

@property (nonatomic,retain) UIColor *backgroundColor;
@property (nonatomic,retain) UIColor *backgroundGradientColor;
@property (nonatomic,retain) UIColor *blurColor;
@property (nonatomic,retain) UIColor *contentColor;
@property (nonatomic,retain) UIColor *headerColor;
@property (nonatomic,retain) UIColor *outlineColor;

@property (nonatomic,assign) bool dynamicHeaderColor;
@property (nonatomic,assign) bool dynamicBackgroundColor;
@property (nonatomic,assign) bool dynamicContentColor;
@property (nonatomic,assign) bool dynamicOutlineColor;

@property (nonatomic,assign) bool colorizeHeader;
@property (nonatomic,assign) bool colorizeBackground;
@property (nonatomic,assign) bool colorizeContent;
@property (nonatomic,assign) bool colorizeSection;

@property (nonatomic,assign) bool backgroundGradient;

@property (nonatomic,assign) bool hideIcon;
@property (nonatomic,assign) bool hideAppName;
@property (nonatomic,assign) bool hideHeaderBackground;
@property (nonatomic,assign) bool hideTime;
@property (nonatomic,assign) bool hideX;
@property (nonatomic,assign) bool outline;

@property (nonatomic,assign) bool hideNoOlder;
@property (nonatomic,assign) bool centerText;
@property (nonatomic,assign) bool pullToClearAll;

@property (nonatomic,assign) double verticalOffset;
@property (nonatomic,assign) double verticalOffsetNotifications;
@property (nonatomic,assign) double verticalOffsetNowPlaying;
@property (nonatomic,assign) double notificationSpacing;
@property (nonatomic,assign) double outlineThickness;
@property (nonatomic,assign) int style;
@property (nonatomic,assign) double alpha;
@property (nonatomic,assign) double backgroundBlurAlpha;
@property (nonatomic,assign) double backgroundBlurColorAlpha;
@property (nonatomic,assign) int cornerRadius;
@property (nonatomic,assign) int iconCornerRadius;

@property (nonatomic,assign) bool idleTimerDisabled;
@property (nonatomic,assign) bool experimentalColors;
@property (nonatomic,assign) bool hdIcons;
@property (nonatomic,assign) bool disableIconShadow;

@end

@interface MPUMarqueeView : UIView <CAAnimationDelegate>

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

@interface UIView(Nanobanners)

-(id)_viewControllerForAncestor;

@end

@interface BBAction : NSObject

+(id)actionWithLaunchURL:(id)arg1 callblock:(/*^block*/id)arg2 ;
+(id)actionWithLaunchBundleID:(id)arg1 callblock:(/*^block*/id)arg2 ;
+(id)actionWithCallblock:(/*^block*/id)arg1 ;
+(id)actionWithAppearance:(id)arg1 ;
+(id)actionWithLaunchURL:(id)arg1 ;
+(id)actionWithActivatePluginName:(id)arg1 activationContext:(id)arg2 ;
+(id)actionWithIdentifier:(id)arg1 ;
+(id)actionWithIdentifier:(id)arg1 title:(id)arg2 ;
+(id)actionWithLaunchBundleID:(id)arg1 ;
@end

@interface BBBulletin : NSObject

@property (nonatomic,readonly) NSString * sectionDisplayName; 
@property (nonatomic,readonly) BOOL sectionDisplaysCriticalBulletins; 
@property (nonatomic,readonly) BOOL showsSubtitle; 
@property (nonatomic,readonly) unsigned long long messageNumberOfLines; 
@property (nonatomic,readonly) BOOL usesVariableLayout; 
@property (nonatomic,readonly) BOOL orderSectionUsingRecencyDate; 
@property (nonatomic,readonly) BOOL showsDateInFloatingLockScreenAlert; 
@property (nonatomic,readonly) NSString * subtypeSummaryFormat; 
@property (nonatomic,readonly) NSString * hiddenPreviewsBodyPlaceholder; 
@property (nonatomic,readonly) NSString * missedBannerDescriptionFormat; 
@property (nonatomic,readonly) NSString * fullUnlockActionLabel; 
@property (nonatomic,readonly) NSString * unlockActionLabel; 
@property (nonatomic,readonly) NSSet * alertSuppressionAppIDs; 
@property (nonatomic,readonly) BOOL suppressesAlertsWhenAppIsActive; 
@property (nonatomic,readonly) BOOL coalescesWhenLocked; 
@property (nonatomic,readonly) unsigned long long realertCount; 
@property (nonatomic,readonly) BOOL inertWhenLocked; 
@property (nonatomic,readonly) BOOL preservesUnlockActionCase; 
@property (nonatomic,readonly) BOOL visuallyIndicatesWhenDateIsInFuture; 
@property (nonatomic,readonly) NSString * fullAlternateActionLabel; 
@property (nonatomic,readonly) NSString * alternateActionLabel; 
@property (nonatomic,readonly) BOOL canBeSilencedByMenuButtonPress; 
@property (nonatomic,readonly) BOOL preventLock; 
@property (nonatomic,readonly) BOOL suppressesTitle; 
@property (nonatomic,readonly) BOOL showsUnreadIndicatorForNoticesFeed; 
@property (nonatomic,readonly) BOOL showsContactPhoto; 
@property (nonatomic,readonly) BOOL playsSoundForModify; 
@property (nonatomic,readonly) BOOL allowsAutomaticRemovalFromLockScreen; 
@property (nonatomic,readonly) BOOL allowsAddingToLockScreenWhenUnlocked; 
@property (nonatomic,readonly) BOOL prioritizeAtTopOfLockScreen; 
@property (nonatomic,readonly) BOOL preemptsPresentedAlert; 
@property (nonatomic,readonly) BOOL revealsAdditionalContentOnPresentation; 
@property (nonatomic,readonly) BOOL shouldDismissBulletinWhenClosed; 
@property (nonatomic,readonly) unsigned long long subtypePriority; 
@property (nonatomic,readonly) long long iPodOutAlertType; 
@property (nonatomic,readonly) NSString * bannerAccessoryRemoteViewControllerClassName; 
@property (nonatomic,readonly) NSString * bannerAccessoryRemoteServiceBundleIdentifier; 
@property (nonatomic,readonly) NSString * secondaryContentRemoteViewControllerClassName; 
@property (nonatomic,readonly) NSString * secondaryContentRemoteServiceBundleIdentifier; 
@property (nonatomic,readonly) unsigned long long privacySettings; 
@property (nonatomic,readonly) BOOL suppressesMessageForPrivacy; 
@property (nonatomic,readonly) NSString * topic; 
@property (nonatomic,copy) NSString * section; 
@property (nonatomic,copy) NSString * sectionID;                                                      //@synthesize sectionID=_sectionID - In the implementation block
@property (nonatomic,copy) NSSet * subsectionIDs;                                                     //@synthesize subsectionIDs=_subsectionIDs - In the implementation block
@property (nonatomic,copy) NSString * recordID;                                                       //@synthesize publisherRecordID=_publisherRecordID - In the implementation block
@property (nonatomic,copy) NSString * publisherBulletinID;                                            //@synthesize publisherBulletinID=_publisherBulletinID - In the implementation block
@property (nonatomic,copy) NSString * dismissalID;                                                    //@synthesize dismissalID=_dismissalID - In the implementation block
@property (nonatomic,copy) NSString * categoryID;                                                     //@synthesize categoryID=_categoryID - In the implementation block
@property (nonatomic,copy) NSString * threadID;                                                       //@synthesize threadID=_threadID - In the implementation block
@property (nonatomic,copy) NSArray * peopleIDs;                                                       //@synthesize peopleIDs=_peopleIDs - In the implementation block
@property (assign,nonatomic) long long addressBookRecordID;                                           //@synthesize addressBookRecordID=_addressBookRecordID - In the implementation block
@property (assign,nonatomic) long long sectionSubtype;                                                //@synthesize sectionSubtype=_sectionSubtype - In the implementation block
@property (nonatomic,copy) NSArray * intentIDs;                                                       //@synthesize intentIDs=_intentIDs - In the implementation block
@property (assign,nonatomic) unsigned long long counter;                                              //@synthesize counter=_counter - In the implementation block
@property (nonatomic,copy) NSString * header;                                                         //@synthesize header=_header - In the implementation block
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSString * subtitle; 
@property (nonatomic,copy) NSString * message; 
@property (nonatomic,copy) NSString * summaryArgument;                                                //@synthesize summaryArgument=_summaryArgument - In the implementation block
@property (assign,nonatomic) unsigned long long summaryArgumentCount;                                 //@synthesize summaryArgumentCount=_summaryArgumentCount - In the implementation block
@property (assign,nonatomic) BOOL hasCriticalIcon;                                                    //@synthesize hasCriticalIcon=_hasCriticalIcon - In the implementation block
@property (assign,nonatomic) BOOL hasEventDate;                                                       //@synthesize hasEventDate=_hasEventDate - In the implementation block
@property (nonatomic,retain) NSDate * date;                                                           //@synthesize date=_date - In the implementation block
@property (nonatomic,retain) NSDate * endDate;                                                        //@synthesize endDate=_endDate - In the implementation block
@property (nonatomic,retain) NSDate * recencyDate;                                                    //@synthesize recencyDate=_recencyDate - In the implementation block
@property (assign,nonatomic) long long dateFormatStyle;                                               //@synthesize dateFormatStyle=_dateFormatStyle - In the implementation block
@property (assign,nonatomic) BOOL dateIsAllDay;                                                       //@synthesize dateIsAllDay=_dateIsAllDay - In the implementation block
@property (nonatomic,retain) NSTimeZone * timeZone;                                                   //@synthesize timeZone=_timeZone - In the implementation block
@property (assign,nonatomic) BOOL clearable;                                                          //@synthesize clearable=_clearable - In the implementation block
@property (assign,nonatomic) BOOL turnsOnDisplay;                                                     //@synthesize turnsOnDisplay=_turnsOnDisplay - In the implementation block
@property (nonatomic,copy) NSArray * additionalAttachments;                                           //@synthesize additionalAttachments=_additionalAttachments - In the implementation block
@property (assign,nonatomic) BOOL wantsFullscreenPresentation;                                        //@synthesize wantsFullscreenPresentation=_wantsFullscreenPresentation - In the implementation block
@property (assign,nonatomic) BOOL ignoresQuietMode;                                                   //@synthesize ignoresQuietMode=_ignoresQuietMode - In the implementation block
@property (assign,nonatomic) BOOL ignoresDowntime;                                                    //@synthesize ignoresDowntime=_ignoresDowntime - In the implementation block
@property (nonatomic,copy) NSString * unlockActionLabelOverride;                                      //@synthesize unlockActionLabelOverride=_unlockActionLabelOverride - In the implementation block
@property (nonatomic,copy) BBAction * defaultAction; 
@property (nonatomic,copy) BBAction * alternateAction; 
@property (nonatomic,copy) BBAction * acknowledgeAction; 
@property (nonatomic,copy) BBAction * snoozeAction; 
@property (nonatomic,copy) BBAction * raiseAction; 
@property (nonatomic,copy) NSArray * buttons;                                                         //@synthesize buttons=_buttons - In the implementation block
@property (nonatomic,retain) NSMutableDictionary * actions;                                           //@synthesize actions=_actions - In the implementation block
@property (nonatomic,retain) NSMutableDictionary * supplementaryActionsByLayout;                      //@synthesize supplementaryActionsByLayout=_supplementaryActionsByLayout - In the implementation block
@property (nonatomic,copy) NSSet * alertSuppressionContexts;                                          //@synthesize alertSuppressionContexts=_alertSuppressionContexts - In the implementation block
@property (assign,nonatomic) BOOL expiresOnPublisherDeath;                                            //@synthesize expiresOnPublisherDeath=_expiresOnPublisherDeath - In the implementation block
@property (nonatomic,retain) NSDictionary * context;                                                  //@synthesize context=_context - In the implementation block
@property (assign,nonatomic) BOOL usesExternalSync;                                                   //@synthesize usesExternalSync=_usesExternalSync - In the implementation block
@property (nonatomic,copy) NSString * bulletinID;                                                     //@synthesize bulletinID=_bulletinID - In the implementation block
@property (nonatomic,retain) NSDate * lastInterruptDate;                                              //@synthesize lastInterruptDate=_lastInterruptDate - In the implementation block
@property (nonatomic,retain) NSDate * publicationDate;                                                //@synthesize publicationDate=_publicationDate - In the implementation block
@property (nonatomic,copy) NSString * bulletinVersionID;                                              //@synthesize bulletinVersionID=_bulletinVersionID - In the implementation block
@property (nonatomic,retain) NSDate * expirationDate;                                                 //@synthesize expirationDate=_expirationDate - In the implementation block
@property (assign,nonatomic) unsigned long long expirationEvents;                                     //@synthesize expirationEvents=_expirationEvents - In the implementation block
@property (nonatomic,copy) BBAction * expireAction; 
@property (assign,nonatomic) unsigned long long realertCount_deprecated; 
@property (nonatomic,copy) NSSet * alertSuppressionAppIDs_deprecated; 
@property (nonatomic,copy) NSString * parentSectionID;                                                //@synthesize parentSectionID=_parentSectionID - In the implementation block
@property (nonatomic,copy) NSString * universalSectionID;                                             //@synthesize universalSectionID=_universalSectionID - In the implementation block
@property (assign,nonatomic) BOOL hasPrivateContent; 
@property (assign,nonatomic) long long contentPreviewSetting;                                         //@synthesize contentPreviewSetting=_contentPreviewSetting - In the implementation block
@property (assign,nonatomic) BOOL preventAutomaticRemovalFromLockScreen;                              //@synthesize preventAutomaticRemovalFromLockScreen=_preventAutomaticRemovalFromLockScreen - In the implementation block
@property (assign,nonatomic) long long lockScreenPriority;                                            //@synthesize lockScreenPriority=_lockScreenPriority - In the implementation block
@property (assign,nonatomic) long long backgroundStyle;                                               //@synthesize backgroundStyle=_backgroundStyle - In the implementation block
@property (nonatomic,copy,readonly) NSString * publisherMatchID; 

@end

@interface BBServer : NSObject
-(id)_sectionInfoForSectionID:(NSString *)arg1 effective:(BOOL)arg2 ;
-(void)publishBulletin:(BBBulletin *)arg1 destinations:(NSUInteger)arg2 alwaysToLockScreen:(BOOL)arg3 ;
-(void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2 ;
-(id)initWithQueue:(id)arg1 ;
-(id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 ;

@end

@interface _MTBackdropView : UIView

@property (assign,setter=_setPreservesFiltersAtZero:,getter=_preservesFiltersAtZero,nonatomic) BOOL preservesFiltersAtZero;              //@synthesize preservesFiltersAtZero=_preservesFiltersAtZero - In the implementation block
@property (assign,nonatomic) double luminanceAlpha; 
@property (assign,nonatomic) double blurRadius; 
@property (nonatomic,copy) NSString * blurInputQuality; 
@property (assign,nonatomic) double saturation; 
@property (assign,nonatomic) double brightness; 
@property (assign,nonatomic) double zoom; 
@property (nonatomic,copy) UIColor * colorMatrixColor;                                                                                   //@synthesize colorMatrixColor=_colorMatrixColor - In the implementation block
@property (nonatomic,copy) UIColor * colorAddColor;                                                                                      //@synthesize colorAddColor=_colorAddColor - In the implementation block
@property (nonatomic,copy) NSString * groupName; 
+(id)_luminanceColorMapWithName:(id)arg1 ;
+(Class)layerClass;
-(double)luminanceAlpha;
-(void)setLuminanceAlpha:(double)arg1 ;
-(id)_luminanceColorMapName;
-(NSString *)blurInputQuality;
-(UIColor *)colorMatrixColor;
-(UIColor *)colorAddColor;
-(void)_setPreservesFiltersAtZero:(BOOL)arg1 ;
-(id)_backdropLayer;
-(void)setBlurInputQuality:(NSString *)arg1 ;
-(void)_setLuminanceColorMapName:(id)arg1 ;
-(void)setColorMatrixColor:(UIColor *)arg1 ;
-(void)setColorAddColor:(UIColor *)arg1 ;
-(void)_setFloatValue:(double)arg1 forFilterOfType:(id)arg2 valueKey:(id)arg3 configurationBlock:(/*^block*/id)arg4 ;
-(void)_setValue:(id)arg1 forFilterOfType:(id)arg2 valueKey:(id)arg3 configurationBlock:(/*^block*/id)arg4 ;
-(void)_configureFilterOfTypeIfNecessary:(id)arg1 withConfigurationBlock:(/*^block*/id)arg2 ;
-(void)_removeFilterOfTypeIfNecessary:(id)arg1 ;
-(BOOL)_preservesFiltersAtZero;
-(double)saturation;
-(void)setSaturation:(double)arg1 ;
-(void)setBlurRadius:(double)arg1 ;
-(BOOL)_shouldAnimatePropertyWithKey:(id)arg1 ;
-(void)setZoom:(double)arg1 ;
-(double)zoom;
-(void)setGroupName:(NSString *)arg1 ;
-(double)blurRadius;
-(NSString *)groupName;
-(void)setBrightness:(double)arg1 ;
-(double)brightness;
@end


@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 ;
@end

@interface _UIBackdropEffectView : UIView
@property (nonatomic,retain) CALayer * backdropLayer;   
@end

@interface _UIBackdropView : UIView {
	int  _style;
}
@property (nonatomic, retain) UIView *grayscaleTintView;
@property (nonatomic, retain) UIView *colorTintView;
@property (nonatomic) int style;
@property (nonatomic) BOOL requiresTintViews;
@property (nonatomic,retain) _UIBackdropEffectView * backdropEffectView;


- (id)init;
- (id)initWithFrame:(CGRect)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithFrame:(CGRect)arg1 privateStyle:(int)arg2;
- (id)initWithFrame:(CGRect)arg1 settings:(id)arg2;
- (id)initWithFrame:(CGRect)arg1 style:(int)arg2;
- (id)initWithPrivateStyle:(int)arg1;
- (id)initWithSettings:(id)arg1;
- (id)initWithStyle:(int)arg1;
- (void)transitionToColor:(id)arg1;
-(UIImage *)darkeningTintMaskImage;
-(void)setComputeAndApplySettingsNotificationObserver:(id)arg1 ;
-(double)colorMatrixGrayscaleTintLevel;
-(void)setColorMatrixGrayscaleTintLevel:(double)arg1 ;
-(double)colorMatrixGrayscaleTintAlpha;
-(void)setColorMatrixGrayscaleTintAlpha:(double)arg1 ;
-(UIColor *)colorMatrixColorTint;
-(void)setColorMatrixColorTint:(UIColor *)arg1 ;
-(double)colorMatrixColorTintAlpha;
-(void)setColorMatrixColorTintAlpha:(double)arg1 ;

@end

@interface MTMaterialView : UIView {//<MTMaterialSettingsObserving> {

	//<MTMaterialSettings>* _settings;
	unsigned long long _options;
	UIView* _backdropView;
	UIView* _primaryOverlayView;
	UIView* _secondaryOverlayView;
	bool _cornerRadiusIsContinuous;
	bool _isConfiguredAsOverlay;
	bool _isInitialWeighting;
	bool _highlighted;
	bool _shouldCrossfadeIfNecessary;
	bool _forceCrossfadeIfNecessary;
	double _weighting;
	/*^block*/ id _backdropScaleAdjustment;

}

@property (nonatomic,copy) NSString * groupName;

//@property (nonatomic,readonly) <MTMaterialSettings><MTMaterialSettingsObservable>* materialSettings; 
//@property (nonatomic,__weak,readonly) MTVibrantStylingProvider* vibrantStylingProvider; 
@property (assign,getter=isHighlighted,nonatomic) bool highlighted; 
@property (assign,nonatomic) bool allowsInPlaceFiltering; 
@property (nonatomic,copy) id backdropScaleAdjustment; 
@property (assign,nonatomic) bool shouldCrossfadeIfNecessary; 
@property (assign,nonatomic) bool forceCrossfadeIfNecessary; 
@property (assign,nonatomic) double weighting;    
@property (readonly) Class superclass; 
@property (copy,readonly) NSString* description; 
@property (copy,readonly) NSString* debugDescription; 
+(void)initialize;
+(id)materialViewWithRecipe:(long long)arg1 options:(unsigned long long)arg2 ;
+(id)materialViewWithRecipe:(long long)arg1 options:(unsigned long long)arg2 initialWeighting:(double)arg3 scaleAdjustment:(/*^block*/ id)arg4 ;
+(void)_validateRecipe:(long long*)arg1 andOptions:(unsigned long long*)arg2 ;
+(id)materialViewWithSettings:(id)arg1 options:(unsigned long long)arg2 initialWeighting:(double)arg3 scaleAdjustment:(/*^block*/ id)arg4 ;
+(id)materialViewWithRecipe:(long long)arg1 options:(unsigned long long)arg2 initialWeighting:(double)arg3 ;
-(bool)allowsInPlaceFiltering;
-(void)setAllowsInPlaceFiltering:(bool)arg1 ;
-(double)cornerRadius;
-(void)dealloc;
-(void)setHighlighted:(bool)arg1 ;
-(bool)isHighlighted;
-(void)_setContinuousCornerRadius:(double)arg1 ;
-(double)_continuousCornerRadius;
-(void)_setCornerRadius:(double)arg1 ;
-(void)settings:(id)arg1 changedValueForKey:(id)arg2 ;
-(double)weighting;
-(void)setWeighting:(double)arg1 ;
-(id)materialSettings;
-(id)_observableSettings;
-(bool)_isCrossfadeNecessary;
-(void)_configureIfNecessaryWithWeighting:(double)arg1 ;
-(void)_reduceTransparencyStatusDidChange;
-(id)_basicOverlaySettings;
-(bool)_supportsVariableWeighting;
-(id)_mtBackdropView;
-(void)_configureMTBackdropView:(id)arg1 withWeighting:(double)arg2 ;
-(void)_configureOverlayView:(id)arg1 withColor:(id)arg2 alpha:(double)arg3 weighting:(double)arg4 ;
-(void)_configureBackdropViewIfNecessaryWithWeighting:(double)arg1 ;
-(void)_configurePrimaryOverlayViewIfNecessaryWithWeighting:(double)arg1 ;
-(void)_configureSecondaryOverlayViewIfNecessaryWithWeighting:(double)arg1 ;
-(id)_backdropViewSettingsForMaterialSettings:(id)arg1 options:(unsigned long long)arg2 ;
-(id)_backdropLayer;
-(id)_luminanceOverlaySettings;
-(void)_adjustScaleOfBackdropView:(id)arg1 ifNecessaryWithWeighting:(double)arg2 ;
-(void)setBackdropScaleAdjustment:(/*^block*/ id)arg1 ;
-(id)_configureOverlayView:(id*)arg1 ofClass:(Class)arg2 withOptions:(unsigned long long)arg3 color:(id)arg4 alpha:(double)arg5 weighting:(double)arg6 ;
-(id)_configureOverlayView:(id*)arg1 withOptions:(unsigned long long)arg2 color:(id)arg3 alpha:(double)arg4 weighting:(double)arg5 ;
-(void)_transitionToSettings:(id)arg1 options:(unsigned long long)arg2 ;
-(id)initWithSettings:(id)arg1 options:(unsigned long long)arg2 initialWeighting:(double)arg3 scaleAdjustment:(/*^block*/ id)arg4 ;
-(/*^block*/ id)backdropScaleAdjustment;
-(bool)shouldCrossfadeIfNecessary;
-(void)setShouldCrossfadeIfNecessary:(bool)arg1 ;
-(bool)forceCrossfadeIfNecessary;
-(void)setForceCrossfadeIfNecessary:(bool)arg1 ;
-(id)vibrantStylingProvider;



@end


@interface MTPlatterView : UIView {//<MTMaterialSettingsObserving, MTPlatterInternal, MTPlatter> {

	long long _recipe;
	unsigned long long _options;
	UIImageView* _shadowView;
	UIView* _mainContainerView;
	MTMaterialView* _mainOverlayView;
	UIView* _customContentView;
	bool _hasShadow;
	bool _backgroundBlurred;
	bool _usesBackgroundView;
	UIView* _backgroundView;
	double _cornerRadius;

}

@property (nonatomic,readonly) MTMaterialView* backgroundMaterialView; 
@property (assign,nonatomic) double cornerRadius; 
@property (assign,getter=isHighlighted,nonatomic) bool highlighted; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString* description; 
@property (copy,readonly) NSString* debugDescription; 
@property (assign,nonatomic) bool usesBackgroundView;                                     //@synthesize usesBackgroundView=_usesBackgroundView - In the implementation block
@property (nonatomic,retain) UIView* backgroundView;                                      //@synthesize backgroundView=_backgroundView - In the implementation block
@property (nonatomic,readonly) UIView* customContentView;                                 //@synthesize customContentView=_customContentView - In the implementation block
@property (assign,nonatomic) bool hasShadow;                                              //@synthesize hasShadow=_hasShadow - In the implementation block
@property (assign,getter=isBackgroundBlurred,nonatomic) bool backgroundBlurred;           //@synthesize backgroundBlurred=_backgroundBlurred - In the implementation block
+(id)_shadowImageMask;
+(CGRect)_shadowImage:(id)arg1 frameForPlatterViewBounds:(CGRect)arg2 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setCornerRadius:(double)arg1 ;
-(double)cornerRadius;
-(void)layoutSubviews;
-(void)dealloc;
-(void)setHighlighted:(bool)arg1 ;
-(bool)isHighlighted;
-(void)setBackgroundView:(UIView*)arg1 ;
-(UIView*)backgroundView;
-(unsigned long long)options;
-(void)settings:(id)arg1 changedValueForKey:(id)arg2 ;
-(bool)hasShadow;
-(void)setHasShadow:(bool)arg1 ;
-(id)customContentView;
-(long long)recipe;
-(void)_configureMainOverlayView;
-(void)_configureBackgroundView:(id)arg1 ;
-(unsigned long long)_optionsForBackgroundWithBlur:(bool)arg1 ;
-(id)_newDefaultBackgroundView;
-(void)_configureMainContainerViewIfNecessary;
-(void)_configureShadowViewIfNecessary;
-(void)_configureMainOverlayViewIfNecessary;
-(void)_configureCustomContentView;
-(void)setUsesBackgroundView:(bool)arg1 ;
-(void)_willRemoveCustomContent:(id)arg1 ;
-(bool)usesBackgroundView;
-(CGSize)sizeThatFitsContentWithSize:(CGSize)arg1 ;
-(CGSize)contentSizeForSize:(CGSize)arg1 ;
-(bool)isBackgroundBlurred;
-(void)setBackgroundBlurred:(bool)arg1 ;
-(void)_configureCustomContentViewIfNecessary;
-(id)vibrantStylingProvider;
-(void)_configureBackgroundViewIfNecessary;
-(id)initWithRecipe:(long long)arg1 options:(unsigned long long)arg2 ;
-(id)backgroundMaterialView;
@end



@interface XXPlatterHeaderContentView : UIView {//<BSUIDateLabelDelegate, MTVibrantStylingProviderObserving, MTVibrantStylingRequiring, MTContentSizeCategoryAdjusting> {

	UIButton* _iconButton;
	UIImageView* _iconButtonShadow;
	UIButton* _utilityButton;
	bool _adjustsFontForContentSizeCategory;
	bool _dateAllDay;
	bool _heedsHorizontalLayoutMargins;
	bool _usesLargeTextLayout;
	NSString* _preferredContentSizeCategory;
	NSDate* _date;
	NSTimeZone* _timeZone;
	long long _dateFormatStyle;
	UIView* _utilityView;
	UILabel* _titleLabel;
	UILabel* _outgoingTitleLabel;

}

@property (getter=_titleLabel,nonatomic,readonly) UILabel* titleLabel; 
@property (getter=_outgoingTitleLabel,nonatomic,readonly) UILabel* outgoingTitleLabel; 
@property (getter=_dateLabel,nonatomic,readonly) UILabel* dateLabel; 
@property (getter=_titleLabelFont,nonatomic,readonly) UIFont* titleLabelFont; 
@property (getter=_dateLabelFont,nonatomic,readonly) UIFont* dateLabelFont; 
@property (assign,setter=_setUsesLargeTextLayout:,getter=_usesLargeTextLayout,nonatomic) bool usesLargeTextLayout; 
@property (nonatomic,retain) UIImage* icon; 
@property (nonatomic,retain) NSArray* icons; 
@property (nonatomic,copy) NSString* title; 
@property (nonatomic,copy) NSDate* date;                                                                                      //@synthesize date=_date - In the implementation block
@property (assign,getter=isDateAllDay,nonatomic) bool dateAllDay;                                                             //@synthesize dateAllDay=_dateAllDay - In the implementation block
@property (nonatomic,copy) NSTimeZone* timeZone;                                                                              //@synthesize timeZone=_timeZone - In the implementation block
@property (nonatomic,readonly) UIButton* iconButton;                                                                          //@synthesize iconButton=_iconButton - In the implementation block
@property (nonatomic,readonly) NSArray * iconButtons; //iOS 12
@property (nonatomic,readonly) UIButton* utilityButton; 
@property (nonatomic,retain) UIView* utilityView;                                                                             //@synthesize utilityView=_utilityView - In the implementation block
@property (assign,nonatomic) bool heedsHorizontalLayoutMargins;                                                               //@synthesize heedsHorizontalLayoutMargins=_heedsHorizontalLayoutMargins - In the implementation block
@property (nonatomic,readonly) double contentBaseline; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString* description; 
@property (copy,readonly) NSString* debugDescription; 
@property (assign,nonatomic) bool adjustsFontForContentSizeCategory;                                                          //@synthesize adjustsFontForContentSizeCategory=_adjustsFontForContentSizeCategory - In the implementation block
@property (nonatomic,copy) NSString* preferredContentSizeCategory;                                                            //@synthesize preferredContentSizeCategory=_preferredContentSizeCategory - In the implementation block

-(id)init;
-(void)layoutSubviews;
-(void)dealloc;
-(void)setTitle:(NSString*)arg1 ;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(void)traitCollectionDidChange:(id)arg1 ;
-(NSString*)title;
-(void)setTimeZone:(NSTimeZone*)arg1 ;
-(NSString*)preferredContentSizeCategory;
-(NSDate*)date;
-(void)layoutMarginsDidChange;
-(id)_layoutManager;
-(void)setAdjustsFontForContentSizeCategory:(bool)arg1 ;
-(bool)adjustsFontForContentSizeCategory;
-(void)setDate:(NSDate*)arg1 ;
-(void)setIcon:(UIImage*)arg1 ;
-(id)_titleLabel;
-(NSTimeZone*)timeZone;
-(UIImage*)icon;
-(void)setPreferredContentSizeCategory:(NSString*)arg1 ;
-(id)_newTitleLabel;
-(id)utilityView;
-(bool)heedsHorizontalLayoutMargins;
-(void)setHeedsHorizontalLayoutMargins:(bool)arg1 ;
-(double)contentBaseline;
-(id)_dateLabel;
-(id)_outgoingTitleLabel;
-(id)_utilityButton;
-(void)_recycleDateLabel;
-(id)_titleLabelPreferredFont;
-(id)_updateTitleAttributesForAttributedString:(id)arg1 ;
-(void)_configureTitleLabel:(id)arg1 ;
-(id)_lazyTitleLabel;
-(id)_attributedStringForTitle:(id)arg1 ;
-(void)_setTitleLabel:(id)arg1 ;
-(id)_lazyOutgoingTitleLabel;
-(void)_setOutgoingTitleLabel:(id)arg1 ;
-(id)_dateLabelPreferredFont;
-(void)_tearDownDateLabel;
-(void)_configureDateLabelIfNecessary;
-(void)_setUsesLargeTextLayout:(bool)arg1 ;
-(void)_updateTextAttributesForTitleLabel:(id)arg1 ;
-(void)_updateTextAttributesForDateLabel;
-(void)dateLabelDidChange:(id)arg1 ;
-(void)_configureIconButton;
-(id)_titleLabelFont;
-(void)setUtilityView:(UIView*)arg1 ;
-(id)iconButton;
-(id)_dateLabelFont;
-(bool)adjustForContentSizeCategoryChange;
-(bool)isDateAllDay;
-(void)setDateAllDay:(bool)arg1 ;
-(long long)dateFormatStyle;
-(void)setDateFormatStyle:(long long)arg1 ;
-(id)utilityButton;
-(id)vibrantStylingProvider;
-(void)_layoutTitleLabelWithScale:(double)arg1 ;
-(bool)_usesLargeTextLayout;
-(double)_headerHeightForWidth:(double)arg1 ;
-(id)_fontProvider;
-(void)_configureUtilityButton;
-(void)_configureIconButtonIfNecessary;
-(void)_configureUtilityButtonIfNecessary;
-(void)_updateStylingForTitleLabel:(id)arg1 ;
-(void)_configureDateLabel;
-(void)_updateUtilityButtonFont;
-(void)_updateUtilityButtonVibrantStyling;
-(void)_layoutIconButtonWithScale:(double)arg1 ;
-(void)_layoutUtilityButtonWithScale:(double)arg1 ;
-(void)_layoutDateLabelWithScale:(double)arg1 ;
-(void)_setFontProvider:(id)arg1 ;
-(void)setVibrantStylingProvider:(id)arg1 ;
-(void)_setText:(id)arg1 withFinalLabel:(id)arg2 setter:(/*^block*/ id)arg3 andTransitionLabel:(id)arg4 setter:(/*^block*/ id)arg5 ;
-(void)vibrantStylingDidChangeForProvider:(id)arg1 ;
@end

@interface PLPlatterHeaderContentView : XXPlatterHeaderContentView

@end

@interface MTPlatterHeaderContentView : XXPlatterHeaderContentView

@end

@interface MTTitledPlatterView : MTPlatterView {//<MTPlatterInternal, MTTitled> {

	UIView* _headerContainerView;
	UIView* _headerOverlayView;
	MTPlatterHeaderContentView* _headerContentView;
	bool _sashHidden;

}

@property (assign,getter=isSashHidden,nonatomic) bool sashHidden;                         //@synthesize sashHidden=_sashHidden - In the implementation block
@property (readonly) Class superclass; 
@property (copy,readonly) NSString* description; 
@property (copy,readonly) NSString* debugDescription; 
@property (nonatomic,readonly) UIView* customContentView; 
@property (assign,nonatomic) bool hasShadow; 
@property (assign,getter=isBackgroundBlurred,nonatomic) bool backgroundBlurred; 
@property (assign,nonatomic) bool adjustsFontForContentSizeCategory; 
@property (nonatomic,copy) NSString* preferredContentSizeCategory; 
@property (nonatomic,retain) UIImage* icon; 
@property (nonatomic,copy) NSString* title; 
@property (nonatomic,copy) NSDate* date; 
@property (assign,getter=isDateAllDay,nonatomic) bool dateAllDay; 
@property (nonatomic,copy) NSTimeZone* timeZone; 
@property (nonatomic,readonly) UIButton* iconButton; 
@property (nonatomic,readonly) UIButton* utilityButton; 
-(void)setNeedsLayout;
-(void)layoutSubviews;
-(void)setTitle:(NSString*)arg1 ;
-(void)traitCollectionDidChange:(id)arg1 ;
-(NSString*)title;
-(void)setTimeZone:(NSTimeZone*)arg1 ;
-(NSDate*)date;
-(void)setBackgroundView:(UIView*)arg1 ;
-(void)setAdjustsFontForContentSizeCategory:(bool)arg1 ;
-(bool)adjustsFontForContentSizeCategory;
-(void)setDate:(NSDate*)arg1 ;
-(void)setIcon:(UIImage*)arg1 ;
-(void)settings:(id)arg1 changedValueForKey:(id)arg2 ;
-(NSTimeZone*)timeZone;
-(UIImage*)icon;
-(UIView*)utilityView;
-(void)_configureHeaderContainerViewIfNecessary;
-(void)_configureHeaderOverlayViewIfNecessary;
-(bool)headerHeedsHorizontalLayoutMargins;
-(bool)isSashHidden;
-(void)_configureMainOverlayView;
-(void)setHeaderHeedsHorizontalLayoutMargins:(bool)arg1 ;
-(void)setUtilityView:(id)arg1 ;
-(id)iconButton;
-(CGSize)sizeThatFitsContentWithSize:(CGSize)arg1 ;
-(CGSize)contentSizeForSize:(CGSize)arg1 ;
-(bool)adjustForContentSizeCategoryChange;
-(bool)isDateAllDay;
-(void)setDateAllDay:(bool)arg1 ;
-(long long)dateFormatStyle;
-(void)setDateFormatStyle:(long long)arg1 ;
-(id)utilityButton;
-(void)_configureHeaderContentViewIfNecessary;
-(id)_headerContentView;
-(void)setSashHidden:(bool)arg1 ;
-(void)_configureHeaderContentView;
@end

@interface NCNotificationContentView : UIView {

	long long _lookStyle;
	UIEdgeInsets _contentInsets;
	UIView* _contentView;
	UIImageView* _thumbnailImageView;
	NSMutableDictionary* _widthToFontToStringToMeasuredNumLines;
	NSStringDrawingContext* _drawingContext;
	BOOL _adjustsFontForContentSizeCategory;
	NSString* _preferredContentSizeCategory;
	UIView* _accessoryView;
	UILabel* _primaryLabel;
	UILabel* _outgoingPrimaryLabel;
	UILabel* _primarySubtitleLabel;
	UILabel* _outgoingPrimarySubtitleLabel;
	UITextView* _secondaryTextView;
	UITextView* _outgoingSecondaryTextView;

}

@property (nonatomic,retain) NSString * primaryText; 
@property (nonatomic,retain) NSString * primarySubtitleText; 
@property (nonatomic,retain) NSString * secondaryText; 
@property (nonatomic,retain) UIImage * thumbnail; 
@property (nonatomic,retain) UIView * accessoryView;                                                                                                            //@synthesize accessoryView=_accessoryView - In the implementation block
@property (assign,nonatomic) unsigned long long messageNumberOfLines; 
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription;                                                                             //@synthesize vibrantStylingProvider=_vibrantStylingProvider - In the implementation block
@property (assign,nonatomic) BOOL adjustsFontForContentSizeCategory;                                                                                            //@synthesize adjustsFontForContentSizeCategory=_adjustsFontForContentSizeCategory - In the implementation block
@property (nonatomic,copy) NSString * preferredContentSizeCategory;                                                                                             //@synthesize preferredContentSizeCategory=_preferredContentSizeCategory - In the implementation block
-(void)layoutSubviews;
-(NSString *)debugDescription;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(void)traitCollectionDidChange:(id)arg1 ;
-(NSString *)preferredContentSizeCategory;
-(UIEdgeInsets)_contentInsets;
-(void)setAdjustsFontForContentSizeCategory:(BOOL)arg1 ;
-(BOOL)adjustsFontForContentSizeCategory;
-(UIView *)accessoryView;
-(void)setAccessoryView:(UIView *)arg1 ;
-(id)initWithStyle:(long long)arg1 ;
-(UIImage *)thumbnail;
-(void)setThumbnail:(UIImage *)arg1 ;
-(void)setPreferredContentSizeCategory:(NSString *)arg1 ;
-(BOOL)textView:(id)arg1 shouldInteractWithURL:(id)arg2 inRange:(NSRange)arg3 interaction:(long long)arg4 ;
-(NSString *)secondaryText;
-(void)setPrimaryText:(NSString *)arg1 ;
-(void)setSecondaryText:(NSString *)arg1 ;
-(NSString *)primaryText;
-(void)setMessageNumberOfLines:(unsigned long long)arg1 ;
-(BOOL)adjustForContentSizeCategoryChange;
-(NSString *)primarySubtitleText;
-(void)setPrimarySubtitleText:(NSString *)arg1 ;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(unsigned long long)messageNumberOfLines;
-(id)_fontProvider;
-(void)_setFontProvider:(id)arg1 ;
-(UIEdgeInsets)_contentInsetsForStyle:(long long)arg1 ;
-(id)_lazyPrimaryLabel;
-(id)_lazySecondaryTextView;
-(UIEdgeInsets)_contentInsetsForLongLook;
-(UIEdgeInsets)_contentInsetsForShortLook;
-(long long)_cachedNumberOfMeasuredLinesForText:(id)arg1 withFont:(id)arg2 forWidth:(double)arg3 ;
-(double)_primaryTextBaselineOffsetWithBaseValue:(double)arg1 ;
-(id)_lazyPrimarySubtitleLabel;
-(double)_primarySubtitleTextBaselineOffsetForCurrentStyle;
-(double)_secondaryTextBaselineOffsetForCurrentStyle;
-(double)_secondaryTextBaselineOffsetWithBaseValue:(double)arg1 ;
-(double)_secondaryTextBaselineOffsetFromBottomWithBaseValue:(double)arg1 ;
-(void)_invalidateNumberOfLinesCache;
-(long long)_numberOfMeasuredLinesForText:(id)arg1 withFont:(id)arg2 forSize:(CGSize)arg3 ;
-(long long)_primaryTextMeasuredNumberOfLinesForWidth:(double)arg1 ;
-(long long)_primaryTextNumberOfLinesWithMeasuredNumberOfLines:(long long)arg1 ;
-(long long)_primarySubtitleTextMeasuredNumberOfLinesForWidth:(double)arg1 ;
-(long long)_primarySubtitleTextNumberOfLinesWithMeasuredNumberOfLines:(long long)arg1 ;
-(long long)_secondaryTextMeasuredNumberOfLinesForWidth:(double)arg1 ;
-(long long)_secondaryTextNumberOfLinesWithMeasuredNumberOfLines:(long long)arg1 ;
-(CGRect)_primaryLabelBoundsForSize:(CGSize)arg1 withContentInsets:(UIEdgeInsets)arg2 andNumberOfLines:(double)arg3 ;
-(CGRect)_primarySubtitleLabelBoundsForSize:(CGSize)arg1 withContentInsets:(UIEdgeInsets)arg2 andNumberOfLines:(double)arg3 ;
-(CGRect)_secondaryTextViewBoundsForSize:(CGSize)arg1 withContentInsets:(UIEdgeInsets)arg2 andNumberOfLines:(double)arg3 ;
-(CGSize)_sizeThatFits:(CGSize)arg1 withContentInsets:(UIEdgeInsets)arg2 ;
-(void)_setText:(id)arg1 withFinalTextDisplayingView:(id)arg2 setter:(/*^block*/id)arg3 andTransitionTextDisplayingView:(id)arg4 setter:(/*^block*/id)arg5 ;
-(void)_updateTextAttributesForLabel:(id)arg1 ;
-(void)_updateTextAttributesForPrimaryLabel:(id)arg1 withStyle:(long long)arg2 ;
-(id)_newPrimaryLabel;
-(void)_updateStyleForPrimaryLabel:(id)arg1 withStyle:(long long)arg2 ;
-(void)_clearCacheForFont:(id)arg1 ;
-(void)_setPrimaryLabel:(id)arg1 ;
-(id)_lazyOutgoingPrimaryLabel;
-(void)_setOutgoingPrimaryLabel:(id)arg1 ;
-(void)_setText:(id)arg1 withFinalLabel:(id)arg2 setter:(/*^block*/id)arg3 andTransitionLabel:(id)arg4 setter:(/*^block*/id)arg5 ;
-(void)_setPrimarySubtitleLabel:(id)arg1 ;
-(id)_lazyOutgoingPrimarySubtitleLabel;
-(void)_setOutgoingPrimarySubtitleLabel:(id)arg1 ;
-(unsigned long long)_secondaryTextNumberOfLines;
-(void)_setSecondaryTextNumberOfLines:(unsigned long long)arg1 ;
-(void)_updateFontForSecondaryTextView:(id)arg1 withStyle:(long long)arg2 ;
-(id)_newSecondaryTextView;
-(void)_updateStyleForSecondaryTextView:(id)arg1 withStyle:(long long)arg2 ;
-(void)_setSecondaryTextView:(id)arg1 ;
-(id)_lazyOutgoingSecondaryTextView;
-(void)_setOutgoingSecondaryTextView:(id)arg1 ;
-(void)_setText:(id)arg1 withFinalTextView:(id)arg2 setter:(/*^block*/id)arg3 andTransitionLabel:(id)arg4 setter:(/*^block*/id)arg5 ;
-(id)_lazyThumbnailImageView;
-(CGRect)_frameForThumbnailInRect:(CGRect)arg1 ;
-(void)vibrantStylingDidChangeForProvider:(id)arg1 ;
-(id)_primaryLabel;
-(id)_secondaryLabel;
-(id)_summaryLabel;
-(id)_primarySubtitleLabel;
-(id)_secondaryLabel;
-(id)_summaryLabel;
-(id)_secondaryTextView;
-(id)_outgoingPrimaryLabel;
-(id)_outgoingPrimarySubtitleLabel;
-(id)_outgoingSecondaryTextView;
@end


@interface NCNotificationShortLookView : MTTitledPlatterView

@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
@property (nonatomic,retain) UIImage * icon; 
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSDate * date; 
@property (nonatomic,copy) NSTimeZone * timeZone; 
@property (nonatomic,copy) NSString * primaryText; 
@property (nonatomic,copy) NSString * primarySubtitleText; 
@property (nonatomic,copy) NSString * secondaryText; 
@property (nonatomic,retain) NSArray * interfaceActions; 
@property (nonatomic,retain) UIImage * thumbnail; 
@property (nonatomic,retain) UIView * accessoryView; 
@property (assign,nonatomic) unsigned long long messageNumberOfLines; 

@property (nonatomic, retain) UIColor *ntfDynamicColor;

-(NTFConfig *)ntfConfig;

-(id)init;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(void)setBackgroundView:(id)arg1 ;
-(void)setAdjustsFontForContentSizeCategory:(BOOL)arg1 ;
-(BOOL)adjustsFontForContentSizeCategory;
-(UIView *)accessoryView;
-(void)setAccessoryView:(UIView *)arg1 ;
-(UIImage *)thumbnail;
-(void)setThumbnail:(UIImage *)arg1 ;
-(NSString *)secondaryText;
-(void)setPrimaryText:(NSString *)arg1 ;
-(void)setSecondaryText:(NSString *)arg1 ;
-(void)setInterfaceActions:(NSArray *)arg1 ;
-(NSArray *)interfaceActions;
-(NSString *)primaryText;
-(void)setMessageNumberOfLines:(unsigned long long)arg1 ;
-(CGSize)sizeThatFitsContentWithSize:(CGSize)arg1 ;
-(CGSize)contentSizeForSize:(CGSize)arg1 ;
-(BOOL)adjustForContentSizeCategoryChange;
-(NSString *)primarySubtitleText;
-(void)setPrimarySubtitleText:(NSString *)arg1 ;
-(void)_configureNotificationContentViewIfNecessary;
-(unsigned long long)messageNumberOfLines;
-(id)_notificationContentView;
-(id)_fontProvider;
-(void)_setFontProvider:(id)arg1 ;
-(void)_configureHeaderContentView;
-(id)_newNotificationContentView;
-(void)_layoutGrabber;
-(BOOL)_shouldShowGrabber;
-(id)_grabberView;

@property (nonatomic, retain) UIView *nanoView;
@property (nonatomic, retain) MPUMarqueeView *nanoMarqueeView;
@property (nonatomic, retain) UIStackView *nanoStackView;
@property (nonatomic, retain) UIImageView *nanoIconView;
@property (nonatomic, retain) UILabel *nanoAppLabel;
@property (nonatomic, retain) UILabel *nanoTitleLabel;
@property (nonatomic, retain) UILabel *nanoTextLabel;

@end

@interface BSUIEmojiLabelView : UIView

-(UILabel*)contentLabel;

@end

@interface BSUIRelativeDateLabel : UILabel
@end


@interface NCNotificationContent : NSObject

@property (nonatomic,copy,readonly) NSString * header;                           //@synthesize header=_header - In the implementation block
@property (nonatomic,copy,readonly) NSString * title;                            //@synthesize title=_title - In the implementation block
@property (nonatomic,copy,readonly) NSString * subtitle;                         //@synthesize subtitle=_subtitle - In the implementation block
@property (nonatomic,copy,readonly) NSString * message;                          //@synthesize message=_message - In the implementation block
@property (nonatomic,copy,readonly) NSString * topic;                            //@synthesize topic=_topic - In the implementation block

@end

@interface NCNotificationRequest : NSObject

@property (nonatomic,readonly) NCNotificationContent * content;
@property (nonatomic,copy,readonly) NSString *notificationIdentifier;
@property (nonatomic,copy,readonly) BBBulletin* bulletin;

@end

@interface _NCNotificationViewControllerView : UIView 

@property (nonatomic, retain) NCNotificationShortLookView *contentView;

@end

@interface NCNotificationViewController : UIViewController

@property (nonatomic,retain) _NCNotificationViewControllerView* view;
@property (nonatomic,retain) NCNotificationRequest* notificationRequest;

@end

@interface NCNotificationShortLookViewController : NCNotificationViewController

@property (nonatomic,retain) UILabel *sxiNotificationCount;

@end

@interface NCNotificationListCell : UICollectionViewCell

@property (nonatomic,retain) NCNotificationShortLookViewController * contentViewController;                          //@synthesize contentViewController=_contentViewController - In the implementation block

-(void)_configureActionButtonsView:(id)arg1 ;

@end

@interface NCNotificationListCellActionButtonsView : UIView 

@property (nonatomic,retain) UIStackView * buttonsStackView;
@property (nonatomic,retain) UIView * clippingView;

-(void)_layoutButtonsStackView;

@end

@interface NCNotificationListCellActionButton : UIControl

@property (nonatomic, retain) MTMaterialView *backgroundView;
@property (nonatomic, retain) MTMaterialView *backgroundOverlayView;
@property (nonatomic, retain) UILabel *titleLabel;

@end

@interface NCNotificationListSectionRevealHintView : UIView

@end

@interface NCNotificationListCollectionView : UICollectionView

@end

@interface SBDashBoardAdjunctListView : UIView

@end

@interface NCNotificationCombinedListView : UIView

@end

@interface SBPagedScrollView : UIView

@end

@interface SBDashBoardMainPageView : UIView

@end

@interface BBObserver : NSObject

@end

@interface NCBulletinNotificationSource : NSObject
-(BBObserver*)observer;
@end

@interface SBNCNotificationDispatcher : NSObject
-(NCBulletinNotificationSource*)notificationSource;
@end


@interface UIApplication (Notifica)
-(SBNCNotificationDispatcher*)notificationDispatcher;
@end

@interface SBLockScreenManager (Notifica)

+(id)sharedInstanceIfExists;
-(UIViewController *)lockScreenViewController;

@end

@interface SBLockScreenNotificationListController : NSObject

+(id)sharedInstance;
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 ;
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(/*^block*/id)arg5 ;

@end

@interface SBCoverSheetWindow : UIWindow

-(id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5 ;
-(id)initWithScreen:(id)arg1 debugName:(id)arg2 rootViewController:(id)arg3 ;
-(id)initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 ;
-(id)initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 scene:(id)arg4 ;
-(id)initWithScreen:(id)arg1 debugName:(id)arg2 ;

@end

@interface PLPlatterView : UIView

@property (nonatomic,readonly) MTMaterialView * backgroundMaterialView; 
@property (nonatomic,readonly) MTMaterialView * mainOverlayView; 
@property (assign,nonatomic) double cornerRadius; 
@property (nonatomic,retain) UIView * backgroundView;                                          //@synthesize backgroundView=_backgroundView - In the implementation block

@end

@interface NCNotificationViewControllerView : UIView

@property (nonatomic, retain) NCNotificationShortLookView *contentView;

@end

@interface NCNotificationLongLookView : UIView {
	MTPlatterHeaderContentView* _headerContentView;
	NCNotificationContentView* _notificationContentView;
}

-(void)setIcon:(UIImage *)arg1 ;

@end


@interface SBDashBoardAdjunctItemView : MTPlatterView

@end

@interface SBDashBoardMediaControlsView : UIView

@end

@interface MediaControlsHeaderView : UIView
@property (retain,nonatomic) UIImageView *artworkView;
-(void)setArtworkCatalog:(id)arg1 ;
@end

@interface MediaControlsTimeControl : UIControl
@property (retain,nonatomic) UILabel *elapsedTimeLabel;
@property (retain,nonatomic) UIView *elapsedTrack;

@property (retain,nonatomic) UILabel *remainingTimeLabel;
@property (retain,nonatomic) UIView *remainingTrack;

@property (retain,nonatomic) UIView *knobView;

@property (retain,nonatomic) UIImageView *liveBackground;
@property (retain,nonatomic) UILabel *liveLabel;
@end

@interface MediaControlsTransportButton : UIButton

@end

@interface MediaControlsTransportStackView : UIView
@property (retain,nonatomic) MediaControlsTransportButton *leftButton;
@property (retain,nonatomic) MediaControlsTransportButton *middleButton;
@property (retain,nonatomic) MediaControlsTransportButton *rightButton;
@end

@interface MediaControlsContainerView : UIView
@property (retain,nonatomic) MediaControlsTimeControl *mediaControlsTimeControl;
@property (retain,nonatomic) MediaControlsTransportStackView *mediaControlsTransportStackView;

-(void)setStyle:(NSInteger)style;
@end

@interface MediaControlsParentContainerView : UIView
@property (retain,nonatomic) MediaControlsContainerView *mediaControlsContainerView;
@end

@interface MediaControlsPanelViewController : UIViewController
@property (retain,nonatomic) MediaControlsHeaderView *headerView;
@property (retain,nonatomic) MediaControlsParentContainerView *parentContainerView;
@property (retain,nonatomic) NSString *label;

-(void)setStyle:(NSInteger)style;
@end

@interface SBDashBoardMediaControlsViewController : UIViewController {
    MediaControlsPanelViewController *_mediaControlsPanelViewController;
}

-(BOOL)handleEvent:(id)event;
@end

@interface SBDashBoardIdleTimerProvider : NSObject 

-(BOOL)isIdleTimerEnabled;

@end

@interface NCNotificationCombinedListViewController : UICollectionView

-(void)_clearAllPriorityListNotificationRequests;
-(void)_clearAllSectionListNotificationRequests;
-(void)clearAll;

@end

@interface SBCoverSheetPrimarySlidingViewController : UIViewController

-(void)setPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3;
-(bool)isTransitioning;

@end

@interface SBDashBoardCombinedListViewController : UIViewController

-(void)_updateListViewContentInset;

@end

@interface _UILegibilitySettings : NSObject

@property (nonatomic, retain) UIColor *primaryColor;

@end

@interface SBUILegibilityLabel : UIView

@property (nonatomic, retain) _UILegibilitySettings *legibilitySettings;

-(void)setTextColor:(UIColor *)color;
-(void)_updateLabelForLegibilitySettings;
-(void)_updateLegibilityView;

@end

@interface NCNotificationListHeaderTitleView : UIView

@property (nonatomic, retain) SBUILegibilityLabel *titleLabel;

@end

@interface NCToggleControl : UIControl

-(MTMaterialView *)_backgroundMaterialView;
-(MTMaterialView *)_overlayMaterialView;
-(UILabel *)_titleLabel;
-(UIImageView *)_glyphView;

@end

@interface NCToggleControlPair : UIView

@property (nonatomic, retain) NSArray *toggleControls;

@end

@interface NCNotificationListCoalescingControlsView : UIView

@property (nonatomic, retain) NCToggleControlPair *toggleControlPair;

@end

@interface NCNotificationListCoalescingHeaderCell : UICollectionViewCell

@property (nonatomic, retain) NCNotificationListHeaderTitleView *headerTitleView;
@property (nonatomic, retain) NCNotificationListCoalescingControlsView *coalescingControlsView;

@end

@interface SBApplication

-(id)icon:(id)arg1 imageWithFormat:(int)arg2;

@end

@interface SBApplicationController

+(id)sharedInstance;
-(SBApplication *)applicationWithBundleIdentifier:(id)arg1;

@end