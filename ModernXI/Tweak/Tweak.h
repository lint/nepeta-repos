#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <Cephei/HBPreferences.h>
#import <BulletinBoard/BBBulletin.h>
#import <AppList/AppList.h>

@interface _UIBackdropView : UIView {
	int  _style;
}
@property (nonatomic, retain) UIView *colorTintView;
@property (nonatomic) int style;
@property (nonatomic) BOOL requiresTintViews;


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

@interface MTPlatterHeaderContentView : UIView {//<BSUIDateLabelDelegate, MTVibrantStylingProviderObserving, MTVibrantStylingRequiring, MTContentSizeCategoryAdjusting> {

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
@property (nonatomic,copy) NSString* title; 
@property (nonatomic,copy) NSDate* date;                                                                                      //@synthesize date=_date - In the implementation block
@property (assign,getter=isDateAllDay,nonatomic) bool dateAllDay;                                                             //@synthesize dateAllDay=_dateAllDay - In the implementation block
@property (nonatomic,copy) NSTimeZone* timeZone;                                                                              //@synthesize timeZone=_timeZone - In the implementation block
@property (nonatomic,readonly) UIButton* iconButton;                                                                          //@synthesize iconButton=_iconButton - In the implementation block
@property (nonatomic,readonly) UIButton* utilityButton; 
@property (nonatomic,retain) UIView* utilityView;                                                                             //@synthesize utilityView=_utilityView - In the implementation block
@property (assign,nonatomic) bool heedsHorizontalLayoutMargins;                                                               //@synthesize heedsHorizontalLayoutMargins=_heedsHorizontalLayoutMargins - In the implementation block
@property (nonatomic,readonly) double contentBaseline; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString* description; 
@property (copy,readonly) NSString* debugDescription; 
@property (assign,nonatomic) bool adjustsFontForContentSizeCategory;                                                          //@synthesize adjustsFontForContentSizeCategory=_adjustsFontForContentSizeCategory - In the implementation block
@property (nonatomic,copy) NSString* preferredContentSizeCategory;                                                            //@synthesize preferredContentSizeCategory=_preferredContentSizeCategory - In the implementation block
@property (assign,nonatomic) bool mxiIsActive;
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

@interface WGWidgetPlatterView : MTTitledPlatterView {

	UIView* _compatibilityDarkeningView;
	NSString* _longerTitle;
	bool _showingMoreContent;
	//WGWidgetHostingViewController* _widgetHost;
	//WGWidgetListItemViewController* _listItem;
	long long _buttonMode;

}

//@property (assign,nonatomic,__weak) WGWidgetHostingViewController* widgetHost;                      //@synthesize widgetHost=_widgetHost - In the implementation block
//@property (assign,nonatomic,__weak) WGWidgetListItemViewController* listItem;                       //@synthesize listItem=_listItem - In the implementation block
@property (nonatomic,readonly) UIButton* showMoreButton; 
@property (assign,getter=isShowingMoreContent,nonatomic) bool showingMoreContent;                   //@synthesize showingMoreContent=_showingMoreContent - In the implementation block
@property (assign,getter=isShowMoreButtonVisible,nonatomic) bool showMoreButtonVisible; 
@property (nonatomic,readonly) UIButton* addWidgetButton; 
@property (assign,getter=isAddWidgetButtonVisible,nonatomic) bool addWidgetButtonVisible; 
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(CGSize)intrinsicContentSize;
-(id)listItem;
-(long long)buttonMode;
-(void)setButtonMode:(long long)arg1 ;
-(id)initWithFrame:(CGRect)arg1 andCornerRadius:(double)arg2 ;
-(void)setWidgetHost:(id)arg1 ;
-(void)setAddWidgetButtonVisible:(bool)arg1 ;
-(id)addWidgetButton;
-(id)widgetHost;
-(id)showMoreButton;
-(void)iconDidInvalidate:(id)arg1 ;
-(void)_willRemoveCustomContent:(id)arg1 ;
-(void)_updateUtilityButtonForMode:(long long)arg1 ;
-(void)_updateCompatibilityDarkeningViewIfNecessary;
-(bool)_isUtilityButtonVisible;
-(void)_setUtilityButtonVisible:(bool)arg1 ;
-(void)_updateUtilityButtonForMoreContentState:(bool)arg1 ;
-(void)setShowingMoreContent:(bool)arg1 ;
-(void)_handleAddWidget:(id)arg1 ;
-(void)_toggleShowMore:(id)arg1 ;
-(void)setShowMoreButtonVisible:(bool)arg1 ;
-(bool)isShowingMoreContent;
-(bool)isShowMoreButtonVisible;
-(bool)isAddWidgetButtonVisible;
-(void)setListItem:(id)arg1 ;
-(void)setBackgroundBlurred:(bool)arg1 ;
-(void)_configureHeaderContentView;
-(void)_handleIconButton:(id)arg1 ;
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
-(id)_primarySubtitleLabel;
-(id)_secondaryTextView;
-(id)_outgoingPrimaryLabel;
-(id)_outgoingPrimarySubtitleLabel;
-(id)_outgoingSecondaryTextView;
@end

@interface NCNotificationGrabberView : UIView {

	UIView* _pill;

}

@property (nonatomic,retain) UIView * pill;              //@synthesize pill=_pill - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(UIView *)pill;
-(void)setPill:(UIView *)arg1 ;
@end


@interface NCNotificationShortLookView : MTTitledPlatterView {

	NCNotificationContentView* _notificationContentView;
	NCNotificationGrabberView* _grabberView;

}

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

-(void)moveUpBy:(int)y view:(UIView *)view;
@end

@interface BSUIRelativeDateLabel : UILabel
@end

@interface NCNotificationRequest : NSObject

@property (nonatomic,copy,readonly) BBBulletin* bulletin;

@end

@interface NCNotificationViewController : UIViewController

@property (nonatomic,retain) NCNotificationRequest* notificationRequest;

@end

@interface NCNotificationShortLookViewController : NCNotificationViewController

@end