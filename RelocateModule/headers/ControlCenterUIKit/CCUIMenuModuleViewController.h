#import <ControlCenterUIKit/CCUIButtonModuleViewController.h>
#import <ControlCenterUIKit/CCUIContentModuleContentViewController-Protocol.h>

@class UILabel, UIView, MTMaterialView, UIStackView, NSMutableArray, UIScrollView, UILongPressGestureRecognizer, UISelectionFeedbackGenerator, CCUIMenuModuleItemView, CCUIContentModuleContext, NSString;

@interface CCUIMenuModuleViewController : CCUIButtonModuleViewController <UIGestureRecognizerDelegate, CCUIContentModuleContentViewController> {

	UILabel* _titleLabel;
	UIView* _headerSeparatorView;
	UIView* _footerSeparatorView;
	MTMaterialView* _platterMaterialView;
	UIStackView* _menuItemsContainer;
	NSMutableArray* _menuItemsViews;
	UIScrollView* _contentScrollView;
	UIView* _darkeningBackgroundView;
	UILongPressGestureRecognizer* _pressGestureRecognizer;
	UISelectionFeedbackGenerator* _feedbackGenerator;
	BOOL _ignoreMenuItemAtTouchLocationAfterExpanded;
	CGPoint _touchLocationToIgnore;
	CCUIMenuModuleItemView* _footerButtonView;
	BOOL _shouldProvideOwnPlatter;
	BOOL _useTallLayout;
	UIView* _contentView;
	CCUIContentModuleContext* _contentModuleContext;

}

@property (nonatomic,copy) NSString * title; 
@property (nonatomic,readonly) unsigned long long actionsCount; 
@property (nonatomic,readonly) double headerHeight; 
@property (nonatomic,readonly) UIView * contentView;                                              //@synthesize contentView=_contentView - In the implementation block
@property (assign,nonatomic) BOOL shouldProvideOwnPlatter;                                        //@synthesize shouldProvideOwnPlatter=_shouldProvideOwnPlatter - In the implementation block
@property (assign,nonatomic) BOOL useTallLayout;                                                  //@synthesize useTallLayout=_useTallLayout - In the implementation block
@property (assign,nonatomic) CCUIContentModuleContext * contentModuleContext;              //@synthesize contentModuleContext=_contentModuleContext - In the implementation block
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
@property (nonatomic,readonly) double preferredExpandedContentHeight; 
@property (nonatomic,readonly) double preferredExpandedContentWidth; 
@property (nonatomic,readonly) BOOL providesOwnPlatter; 
-(unsigned long long)actionsCount;
-(void)_contentSizeCategoryDidChange;
-(BOOL)shouldBeginTransitionToExpandedContentModule;
-(void)addActionWithTitle:(id)arg1 subtitle:(id)arg2 glyph:(id)arg3 handler:(/*^block*/id)arg4 ;
-(void)setUseTallLayout:(BOOL)arg1 ;
-(double)_titleWidthForContainerWidth:(double)arg1 ;
-(BOOL)_shouldLimitContentSizeCategory;
-(void)_fadeViewsForExpandedState:(BOOL)arg1 ;
-(void)_setupContentViewBounds;
-(void)_setupMenuItems;
-(void)_layoutViewSubviews;
-(void)_layoutGlyphViewForSize:(CGSize)arg1 ;
-(void)_layoutTitleLabelForSize:(CGSize)arg1 ;
-(void)_layoutHeaderSeparatorForSize:(CGSize)arg1 ;
-(void)_layoutFooterSeparatorForSize:(CGSize)arg1 ;
-(void)_layoutFooterButtonForSize:(CGSize)arg1 ;
-(double)preferredExpandedContentHeightWithWidth:(double)arg1 ;
-(double)_maximumHeight;
-(double)_desiredExpandedHeight;
-(double)_menuItemsHeightForWidth:(double)arg1 ;
-(double)_footerHeight;
-(BOOL)_shouldShowFooterSeparator;
-(BOOL)_shouldShowFooterButton;
-(double)_contentScaleForSize:(CGSize)arg1 ;
-(CGAffineTransform)_contentTransformForScale:(double)arg1 ;
-(id)_menuItemAtGestureTouchLocation:(id)arg1 ;
-(id)_menuItemAtLocation:(CGPoint)arg1 ;
-(BOOL)_toggleSelectionForMenuItem:(id)arg1 ;
-(void)_handleActionTapped:(id)arg1 ;
-(BOOL)_shouldShowFooterChin;
-(void)setFooterButtonTitle:(id)arg1 handler:(/*^block*/id)arg2 ;
-(void)removeFooterButton;
-(BOOL)shouldProvideOwnPlatter;
-(void)setShouldProvideOwnPlatter:(BOOL)arg1 ;
-(BOOL)useTallLayout;
-(double)preferredExpandedContentHeight;
-(void)addActionWithTitle:(id)arg1 glyph:(id)arg2 handler:(/*^block*/id)arg3 ;
-(void)willTransitionToExpandedContentMode:(BOOL)arg1 ;
-(double)preferredExpandedContentWidth;
-(CCUIContentModuleContext *)contentModuleContext;
-(void)setContentModuleContext:(CCUIContentModuleContext *)arg1 ;
-(void)_layoutMenuItemsForSize:(CGSize)arg1 ;
-(void)_setupTitleLabel;
-(void)contentModuleWillTransitionToExpandedContentMode:(BOOL)arg1 ;
-(void)_updateScrollViewContentSize;
-(double)headerHeightForWidth:(double)arg1 ;
-(void)dealloc;
-(BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2 ;
-(void)setTitle:(NSString *)arg1 ;
-(UIView *)contentView;
-(id)initWithNibName:(id)arg1 bundle:(id)arg2 ;
-(void)viewDidLoad;
-(void)viewWillLayoutSubviews;
-(void)viewWillTransitionToSize:(CGSize)arg1 withTransitionCoordinator:(id)arg2 ;
-(void)removeAllActions;
-(void)_handlePressGesture:(id)arg1 ;
-(id)_titleFont;
-(double)headerHeight;
-(double)_separatorHeight;
@end