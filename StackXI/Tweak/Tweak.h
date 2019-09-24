#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>
#import <Cephei/HBPreferences.h>
#import <BulletinBoard/BBDataProvider.h>
#import <BulletinBoard/BBBulletin.h>
#import <BulletinBoard/BBAction.h>
#import "../SXICommon.h"

@interface BBBulletin(StackXI)

@property (nonatomic,copy) NSString * threadID;

@end

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

@interface SXIButton : UIView
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) _UIBackdropView *backdropView;
@property (nonatomic, retain) UIView *overlayView;
- (void)addBlurEffect;
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
-(UILabel*)_titleLabel;
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

@property (assign,getter=isSashHidden,nonatomic) bool sashHidden;
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
-(MTPlatterHeaderContentView*)_headerContentView;
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

@property (setter=_setPrimaryLabel:,getter=_primaryLabel,nonatomic,retain) UILabel * primaryLabel;
@property (nonatomic,retain) NSString * primaryText;
@property (nonatomic,retain) NSString * primarySubtitleText;
@property (nonatomic,retain) NSString * secondaryText;
@property (nonatomic,retain) UIImage * thumbnail;
@property (nonatomic,retain) UIView * accessoryView;                                                                                                            //@synthesize accessoryView=_accessoryView - In the implementation block
@property (assign,nonatomic) unsigned long long messageNumberOfLines;
@property (readonly) unsigned long long hash;
@property (assign,nonatomic) BOOL adjustsFontForContentSizeCategory;                                                                                            //@synthesize adjustsFontForContentSizeCategory=_adjustsFontForContentSizeCategory - In the implementation block
@property (nonatomic,copy) NSString * preferredContentSizeCategory;                                                                                             //@synthesize preferredContentSizeCategory=_preferredContentSizeCategory - In the implementation block
-(void)layoutSubviews;
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
-(void)_setPrimaryLabel:(UILabel *)arg1 ;
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
-(UILabel*)_primaryLabel;
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
-(NCNotificationContentView*)_notificationContentView;
-(id)_fontProvider;
-(void)_setFontProvider:(id)arg1 ;
-(void)_configureHeaderContentView;
-(id)_newNotificationContentView;
-(void)_layoutGrabber;
-(BOOL)_sxiVisibleGrabber;
-(id)_grabberView;

-(void)moveUpBy:(int)y view:(UIView *)view;
@end

@interface BSUIRelativeDateLabel : UILabel
@end



@interface BBServer : NSObject
-(id)_sectionInfoForSectionID:(NSString *)arg1 effective:(BOOL)arg2 ;
-(void)publishBulletin:(BBBulletin *)arg1 destinations:(NSUInteger)arg2 alwaysToLockScreen:(BOOL)arg3 ;
-(id)initWithQueue:(id)arg1 ;
-(id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 ;

@end

@interface NCNotificationActionRunner : NSObject

-(void)executeAction:(id)arg1 fromOrigin:(id)arg2 withParameters:(id)arg3 completion:(/*^block*/ id)arg4;
-(bool)shouldForwardAction;
-(void)setShouldForwardAction:(bool)arg1;
@end


@interface NCNotificationAction : NSObject
@property (nonatomic,readonly) NCNotificationActionRunner *actionRunner;
@end

@interface NCNotificationOptions : NSObject
@property (nonatomic,copy,readonly) NSSet * alertSuppressionContexts;                       //@synthesize alertSuppressionContexts=_alertSuppressionContexts - In the implementation block
@property (nonatomic,copy,readonly) NSString * alternateActionLabel;                        //@synthesize alternateActionLabel=_alternateActionLabel - In the implementation block
@property (nonatomic,readonly) BOOL dismissAutomatically;                                   //@synthesize dismissAutomatically=_dismissAutomatically - In the implementation block
@property (nonatomic,readonly) BOOL overridesQuietMode;                                     //@synthesize overridesQuietMode=_overridesQuietMode - In the implementation block
@property (nonatomic,readonly) BOOL alertsWhenLocked;                                       //@synthesize alertsWhenLocked=_alertsWhenLocked - In the implementation block
@property (nonatomic,readonly) BOOL addToLockScreenWhenUnlocked;                            //@synthesize addToLockScreenWhenLocked=_addToLockScreenWhenLocked - In the implementation block
@property (nonatomic,readonly) unsigned long long lockScreenPersistence;                    //@synthesize lockScreenPersistence=_lockScreenPersistence - In the implementation block
@property (nonatomic,readonly) unsigned long long lockScreenPriority;                       //@synthesize lockScreenPriority=_lockScreenPriority - In the implementation block
@property (nonatomic,readonly) unsigned long long realertCount;                             //@synthesize realertCount=_realertCount - In the implementation block
@property (nonatomic,readonly) BOOL suppressesAlertsWhenAppIsActive;                        //@synthesize suppressesAlertsWhenAppIsActive=_suppressesAlertsWhenAppIsActive - In the implementation block
@property (nonatomic,readonly) BOOL canPlaySound;                                           //@synthesize canPlaySound=_canPlaySound - In the implementation block
@property (nonatomic,readonly) BOOL canTurnOnDisplay;                                       //@synthesize canTurnOnDisplay=_canTurnOnDisplay - In the implementation block
@property (nonatomic,readonly) BOOL requestsFullScreenPresentation;                         //@synthesize requestsFullScreenPresentation=_requestsFullScreenPresentation - In the implementation block
@property (nonatomic,readonly) BOOL preemptsPresentedNotification;                          //@synthesize preemptsPresentedNotification=_preemptsPresentedNotification - In the implementation block
@property (nonatomic,readonly) BOOL revealsAdditionalContentOnPresentation;                 //@synthesize revealsAdditionalContentOnPresentation=_revealsAdditionalContentOnPresentation - In the implementation block
@property (nonatomic,readonly) BOOL suppressesTitleWhenLocked;                              //@synthesize suppressesTitleWhenLocked=_suppressesTitleWhenLocked - In the implementation block
@property (nonatomic,readonly) BOOL suppressesSubtitleWhenLocked;                           //@synthesize suppressesSubtitleWhenLocked=_suppressesSubtitleWhenLocked - In the implementation block
@property (nonatomic,readonly) BOOL suppressesBodyWhenLocked;                               //@synthesize suppressesBodyWhenLocked=_suppressesBodyWhenLocked - In the implementation block
@property (nonatomic,readonly) unsigned long long contentPreviewSetting;                    //@synthesize contentPreviewSetting=_contentPreviewSetting - In the implementation block
@property (nonatomic,readonly) BOOL silencedByMenuButtonPress;                              //@synthesize silencedByMenuButtonPress=_silencedByMenuButtonPress - In the implementation block
@property (nonatomic,readonly) BOOL overridesPocketMode;                                    //@synthesize overridesPocketMode=_overridesPocketMode - In the implementation block
@property (nonatomic,readonly) BOOL hideClearActionInList;                                  //@synthesize hideClearActionInList=_hideClearActionInList - In the implementation block
@property (nonatomic,readonly) unsigned long long messageNumberOfLines;                     //@synthesize messageNumberOfLines=_messageNumberOfLines - In the implementation block
@property (nonatomic,readonly) BOOL coalescesWhenLocked;                                    //@synthesize coalescesWhenLocked=_coalescesWhenLocked - In the implementation block
@property (nonatomic,readonly) BOOL preventsAutomaticLock;                                  //@synthesize preventsAutomaticLock=_preventsAutomaticLock - In the implementation block
@property (nonatomic,readonly) BOOL revealsAdditionalContentIfNoDefaultAction;              //@synthesize revealsAdditionalContentIfNoDefaultAction=_revealsAdditionalContentIfNoDefaultAction - In the implementation block
@end

@interface NCNotificationContent : NSObject

@property (nonatomic,copy,readonly) NSString * header;                                     //@synthesize header=_header - In the implementation block
@property (nonatomic,copy,readonly) NSString * title;                                      //@synthesize title=_title - In the implementation block
@property (nonatomic,copy,readonly) NSString * subtitle;                                   //@synthesize subtitle=_subtitle - In the implementation block
@property (nonatomic,copy,readonly) NSString * message;                                    //@synthesize message=_message - In the implementation block
@property (nonatomic,copy,readonly) NSString * hiddenPreviewsBodyPlaceholder;              //@synthesize hiddenPreviewsBodyPlaceholder=_hiddenPreviewsBodyPlaceholder - In the implementation block
@property (nonatomic,copy,readonly) NSString * topic;                                      //@synthesize topic=_topic - In the implementation block

@end

@interface NCNotificationRequest : NSObject

@property (nonatomic,copy,readonly) NSSet* requestDestinations;
@property (nonatomic,copy,readonly) BBBulletin* bulletin;
@property (nonatomic,copy,readonly) NSString* notificationIdentifier;
@property (nonatomic,copy,readonly) NSString *threadIdentifier;
@property (assign,nonatomic) bool sxiIsStack;
@property (assign,nonatomic) bool sxiIsExpanded;
@property (assign,nonatomic) bool sxiVisible;
@property (assign,nonatomic) NSUInteger sxiPositionInStack;
@property (nonatomic,retain) NSMutableOrderedSet *sxiStackedNotificationRequests;
@property (nonatomic,readonly) NCNotificationAction* clearAction;
@property (nonatomic,readonly) NSDate* timestamp;
@property (nonatomic,readonly) NCNotificationOptions* options;
@property (nonatomic,readonly) NCNotificationContent* content;

-(NSString *)sxiStackID;
-(void)sxiInsertRequest:(NCNotificationRequest *)request;
-(void)sxiExpand;
-(void)sxiCollapse;
-(void)sxiClear:(BOOL)reload;
-(void)sxiClearStack;

@end

@interface SBDashBoardCombinedListViewController : UIViewController
-(void)_setListHasContent:(BOOL)arg1;
@end

@interface UICollectionViewControllerWrapperView : UIView

@end

@interface SBDashBoardViewController : UIViewController

@property (assign,getter=isAuthenticated,nonatomic) BOOL authenticated;
-(BOOL)isShowingMediaControls;

@end

@interface _NCNotificationViewControllerView : UIView

@property (nonatomic, retain) NCNotificationShortLookView *contentView;

@end

@interface NCNotificationViewController : UIViewController

@property (nonatomic,retain) NCNotificationRequest* notificationRequest;
@property (getter=_scrollView,nonatomic,readonly) UIScrollView * scrollView;
-(UIView*)_lookView;

@end


@interface NCNotificationShortLookViewController : NCNotificationViewController
@property (nonatomic, retain) UILabel* sxiNotificationCount;
@property (nonatomic, retain) UILabel* sxiTitle;
@property (nonatomic, retain) SXIButton* sxiClearAllButton;
@property (nonatomic, retain) SXIButton* sxiCollapseButton;
@property (assign,nonatomic) bool sxiIsLTR;

-(void)_handleTapOnView:(id)arg1 ;
-(id)_initWithNotificationRequest:(id)arg1 revealingAdditionalContentOnPresentation:(BOOL)arg2 ;
-(id)initWithNotificationRequest:(id)arg1 ;
-(void)_setupStaticContentProvider;
-(void)_updateWithProvidedStaticContent;
-(void)sxiUpdateCount;
-(void)sxiCollapse:(UIButton *)button;
-(void)sxiClearAll:(UIButton *)button;
-(CGRect)sxiGetClearAllButtonFrame;
-(CGRect)sxiGetCollapseButtonFrame;
-(CGRect)sxiGetNotificationCountFrame;
-(CGRect)sxiGetTitleFrame;
-(int)sxiButtonWidth;
-(int)sxiButtonSpacing;

@end

@interface NCNotificationSectionList : NSObject

-(unsigned long long)sectionCount;
-(id)delegate;
-(void)setDelegate:(id)arg1;
-(id)allNotificationRequests;
-(bool)containsNotificationRequest:(id)arg1;
-(id)removeNotificationRequest:(id)arg1;
-(id)insertNotificationRequest:(id)arg1;
-(id)modifyNotificationRequest:(id)arg1;
-(id)notificationRequestAtIndexPath:(id)arg1;
-(id)requestsIndexPathsPassingTest:(/*^block*/ id)arg1;
-(void)hideRequestsForNotificationSectionIdentifier:(id)arg1 subSectionIdentifier:(id)arg2;
-(void)showRequestsForNotificationSectionIdentifier:(id)arg1 subSectionIdentifier:(id)arg2;
-(unsigned long long)rowCountForSectionIndex:(unsigned long long)arg1;
-(id)titleForSectionIndex:(unsigned long long)arg1;
-(id)identifierForSectionIndex:(unsigned long long)arg1;
-(id)notificationRequestsForSectionIdentifier:(id)arg1;
-(id)dateForSectionIdentifier:(id)arg1;
-(void)clearSectionWithIdentifier:(id)arg1;
-(void)clearAllSections;
-(long long)sectionIndexForListSectionIdentifier:(id)arg1;
-(id)notificationRequestsAtIndexPaths:(id)arg1;

@end

@interface NCNotificationPriorityList : NSObject

@property (nonatomic,retain) NSMutableOrderedSet* requests;           //@synthesize requests=_requests - In the implementation block
@property (nonatomic,retain) NSMutableOrderedSet* sxiAllRequests;
@property (nonatomic,readonly) unsigned long long count;
-(NSMutableOrderedSet*)requests;
-(id)requestAtIndex:(unsigned long long)arg1 ;
-(void)setRequests:(NSMutableOrderedSet*)arg1 ;
-(id)init;
-(void)sxiUpdateList;
-(unsigned long long)count;
-(id)allNotificationRequests;
-(bool)containsNotificationRequestMatchingRequest:(id)arg1 ;
-(unsigned long long)removeNotificationRequest:(id)arg1 ;
-(unsigned long long)insertionIndexForNotificationRequest:(id)arg1 ;
-(unsigned long long)insertNotificationRequest:(id)arg1 ;
-(unsigned long long)indexOfNotificationRequestMatchingRequest:(id)arg1 ;
-(unsigned long long)modifyNotificationRequest:(id)arg1 ;
-(id)clearNonPersistentRequests;
-(id)clearRequestsPassingTest:(/*^block*/ id)arg1 ;
-(unsigned long long)_insertionIndexForNotificationRequest:(id)arg1 ;
-(unsigned long long)_indexOfRequestMatchingNotificationRequest:(id)arg1 ;
-(id)_clearRequestsWithPersistence:(unsigned long long)arg1 ;
-(id)_identifierForNotificationRequest:(id)arg1 ;
-(id)clearAllRequests;
-(void)sxiClearAll;

@end

@interface NCNotificationListCollectionView : UICollectionView

-(id)cellForItemAtIndexPath:(id)arg1 ;
-(id)_visibleCellForIndexPath:(id)arg1 ;
-(unsigned long long)_updateVisibleCellsNow:(BOOL)arg1 ;
-(void)_setNeedsVisibleCellsUpdate:(BOOL)arg1 withLayoutAttributes:(BOOL)arg2 ;
-(void)sxiExpand:(NSString *)sectionID;
-(void)sxiCollapse:(NSString *)sectionID;
-(void)sxiCollapseAll;
-(void)sxiClear:(NSString *)notificationIdentifier;
-(void)sxiClearAll;

@end

@interface NCNotificationListCellActionButton : UIControl
@property (nonatomic,retain) UILabel* titleLabel;
@property (nonatomic,copy) NSString* title;
-(void)setTitle:(NSString *)arg1 ;

@end

@interface NCNotificationListCellActionButtonsView : UIView
@property (nonatomic,retain) NCNotificationListCellActionButton* defaultActionButton;
@end

@interface NCNotificationListCell : UICollectionViewCell

@property (nonatomic,retain) NCNotificationViewController* contentViewController;
@property (nonatomic,retain) NCNotificationListCellActionButtonsView* rightActionButtonsView;
@property (assign,nonatomic) bool sxiReturnSVToOrigFrame;
@property (assign,nonatomic) CGRect sxiSVOrigFrame;

-(instancetype)init;
-(id)initWithFrame:(CGRect)arg1 ;

-(void)cellClearButtonPressed:(id)arg1;
-(void)_executeClearAction;

@end

@interface NCNotificationListSectionRevealHintView : UIView
@end

@interface NCNotificationListViewController : UICollectionViewController

-(BOOL)hasVisibleContent;
-(void)clearAllNonPersistent;

@end

@interface NCNotificationCombinedListViewController : UIViewController

@property (nonatomic,retain) NCNotificationPriorityList * notificationPriorityList;
@property (nonatomic,retain) SXIButton* sxiClearAllButton;
@property (nonatomic,retain) UINotificationFeedbackGenerator* sxiFeedbackGenerator;
@property (assign,nonatomic) BOOL sxiIsLTR;
@property (assign,nonatomic) BOOL sxiClearAllConfirm;
@property (assign,nonatomic) BOOL sxiGRAdded;

-(void)sxiHandleGesture:(UIGestureRecognizer *)gestureRecognizer;
-(void)sxiClearAll:(UIButton *)button;
-(CGRect)sxiGetClearAllButtonFrame;
-(void)sxiUpdateClearAllButton;
-(void)sxiMakeClearAllButton;

-(NCNotificationListCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)reloadNotificationRequestsInNotificationHistorySection:(id)arg1 ;
-(void)insertNotificationRequestsInNotificationHistorySection:(id)arg1 ;
-(void)removeNotificationRequestsInNotificationHistorySection:(id)arg1 ;
-(void)reloadNotificationRequestsInIncomingSection:(id)arg1 ;
-(void)insertNotificationRequestsInIncomingSection:(id)arg1 ;
-(void)removeNotificationRequestsInIncomingSection:(id)arg1 ;
-(long long)numberOfSectionsInCollectionView:(id)arg1 ;
-(long long)collectionView:(id)arg1 numberOfItemsInSection:(long long)arg2;
-(NSMutableSet*)allNotificationRequests;
-(void)removeNotificationRequest:(id)arg1 forCoalescedNotification:(id)arg2 ;
-(void)removeNotificationRequestFromRecentsSection:(id)arg1 forCoalescedNotification:(id)arg2;
-(void)_clearAllPriorityListNotificationRequests;
-(void)_clearAllSectionListNotificationRequests;
-(void)_moveNotificationRequestsToHistorySectionPassingTest:(/*^block*/id)arg1 animated:(BOOL)arg2 movedAll:(BOOL)arg3;
-(BOOL)hasContent;
-(void)clearAllNonPersistent;
-(BOOL)modifyNotificationRequest:(NCNotificationRequest*)arg1 forCoalescedNotification:(id)arg2 ;

@end

@interface NCNotificationListCollectionViewFlowLayout : UICollectionViewFlowLayout

-(id)initialLayoutAttributesForAppearingItemAtIndexPath:(id)arg1;

@end

@interface NCNotificationStore

-(id)init;
-(id)insertNotificationRequest:(NCNotificationRequest*)arg1;
-(id)removeNotificationRequest:(NCNotificationRequest*)arg1;
-(id)replaceNotificationRequest:(NCNotificationRequest*)arg1;

@end

@interface NCNotificationDispatcher : NSObject

-(id)init;
-(void)registerDestination:(id)arg1 ;
-(void)unregisterDestination:(id)arg1 ;
-(void)setDestination:(id)arg1 enabled:(BOOL)arg2 ;
-(void)destination:(id)arg1 requestPermissionToExecuteAction:(id)arg2 forNotificationRequest:(id)arg3 withParameters:(id)arg4 completion:(/*^block*/id)arg5 ;
-(void)destination:(id)arg1 executeAction:(id)arg2 forNotificationRequest:(id)arg3 requestAuthentication:(BOOL)arg4 withParameters:(id)arg5 completion:(/*^block*/id)arg6 ;
-(id)notificationSectionSettingsForDestination:(id)arg1 ;
-(id)notificationSectionSettingsForDestination:(id)arg1 forSectionIdentifier:(id)arg2 ;
-(void)destination:(id)arg1 requestsClearingNotificationRequests:(id)arg2 ;
-(void)destination:(id)arg1 requestsClearingNotificationRequests:(id)arg2 fromDestinations:(id)arg3 ;
-(void)destination:(id)arg1 requestsClearingNotificationRequestsFromDate:(id)arg2 toDate:(id)arg3 inSections:(id)arg4 ;
-(void)destination:(id)arg1 requestsClearingNotificationRequestsInSections:(id)arg2 ;
-(void)destinationDidBecomeReadyToReceiveNotifications:(id)arg1 ;
-(void)destination:(id)arg1 didBecomeReadyToReceiveNotificationsPassingTest:(/*^block*/id)arg2 ;
-(void)destination:(id)arg1 didBecomeReadyToReceiveNotificationsCoalescedWith:(id)arg2 ;
-(void)destination:(id)arg1 willPresentNotificationRequest:(id)arg2 suppressAlerts:(BOOL)arg3 ;
-(void)destination:(id)arg1 didPresentNotificationRequest:(id)arg2 ;
-(void)destination:(id)arg1 didDismissNotificationRequest:(id)arg2 ;
-(void)destination:(id)arg1 willPresentNotificationRequest:(id)arg2 ;
-(NCNotificationStore *)notificationStore;
-(void)_performOperationForRequestDestinations:(id)arg1 block:(/*^block*/id)arg2 ;
-(BOOL)_isRegisteredDestination:(id)arg1 ;
-(void)_registerAlertDestination:(id)arg1 ;
-(void)_registerDestination:(id)arg1 ;
-(id)initWithAlertingController:(id)arg1 ;
-(void)removeDispatcherSourceDelegate:(id)arg1 ;
-(void)setNotificationStore:(NCNotificationStore *)arg1 ;
-(void)addDispatcherSourceDelegate:(id)arg1 ;
-(void)postNotificationWithRequest:(id)arg1 ;
-(void)modifyNotificationWithRequest:(id)arg1 ;
-(void)withdrawNotificationWithRequest:(id)arg1 ;
-(void)updateNotificationSectionSettings:(id)arg1 ;
-(void)removeNotificationSectionWithIdentifier:(id)arg1 ;
@end

@interface NCNotificationChronologicalList : NSObject

@property (nonatomic,readonly) unsigned long long sectionCount;
-(unsigned long long)sectionCount;
-(id)init;
-(NSString *)debugDescription;
-(void)setSections:(NSMutableArray *)arg1 ;
-(NSMutableArray *)sections;
-(void)_handleLocaleChange;
-(void)_handleTimeZoneChange;
-(id)succinctDescription;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(id)succinctDescriptionBuilder;
-(id)allNotificationRequests;
-(BOOL)containsNotificationRequest:(id)arg1 ;
-(id)removeNotificationRequest:(id)arg1 ;
-(id)insertNotificationRequest:(id)arg1 ;
-(id)modifyNotificationRequest:(id)arg1 ;
-(id)notificationRequestAtIndexPath:(id)arg1 ;
-(void)hideRequestsForNotificationSectionIdentifier:(id)arg1 subSectionIdentifier:(id)arg2 ;
-(void)showRequestsForNotificationSectionIdentifier:(id)arg1 subSectionIdentifier:(id)arg2 ;
-(unsigned long long)rowCountForSectionIndex:(unsigned long long)arg1 ;
-(id)titleForSectionIndex:(unsigned long long)arg1 ;
-(id)identifierForSectionIndex:(unsigned long long)arg1 ;
-(id)notificationRequestsForSectionIdentifier:(id)arg1 ;
-(id)dateForSectionIdentifier:(id)arg1 ;
-(void)clearSectionWithIdentifier:(id)arg1 ;
-(void)clearAllSections;
-(void)_updateListForDateChange;
-(id)_sectionContainingNotificationRequest:(id)arg1 ;
-(id)_existingSectionForNotificationRequest:(id)arg1 ;
-(id)_newSectionForNotificationRequest:(id)arg1 ;
-(unsigned long long)_insertionIndexForSection:(id)arg1 ;
-(id)_targetIndexPathForNotificationRequest:(id)arg1 ;
-(long long)sectionIndexForListSectionIdentifier:(id)arg1 ;
-(void)_reloadSectionHeaders;
-(void)_rebuildSectionsList;
-(id)_titleForDate:(id)arg1 ;
-(id)_allNotificationRequestsFromSectionIndex:(unsigned long long)arg1 ;
-(id)_simpleDateFromDate:(id)arg1 ;
-(id)_identifierForDate:(id)arg1 ;
-(id)_newSectionForDate:(id)arg1 ;
-(id)_existingSectionForDate:(id)arg1 ;
-(id)notificationRequestsAtIndexPaths:(id)arg1 ;
-(id)_completeIndexSet;
@end
