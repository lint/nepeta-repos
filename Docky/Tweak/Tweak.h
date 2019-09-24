#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>
#import <Cephei/HBPreferences.h>

typedef struct SBIconCoordinate {
	long long row;
	long long col;
} SBIconCoordinate;

@interface DCKScrollViewDelegate : NSObject <UIScrollViewDelegate>

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

@end

@interface CALayer(Private)

@property (nonatomic, assign) BOOL continuousCorners;

@end

@interface SBIconModel : NSObject

-(void)deleteIconState;
-(NSArray *)exportState:(BOOL)arg1;
-(BOOL)importState:(NSArray *)arg1;
-(void)importDesiredIconState:(NSArray *)arg1 ;
-(void)setIgnoresIconsNotInIconState:(BOOL)arg1 ;


@end

@interface SBIconListView : UIView 

+(unsigned long long)maxIcons;
-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 ;
-(CGPoint)originForIconAtIndex:(unsigned long long)arg1 ;
-(CGSize)defaultIconSize;
-(double)horizontalIconPadding;
-(CGSize)defaultIconSize;
-(double)verticalIconPadding;
-(double)sideIconInset;
-(unsigned long long)iconRowsForSpacingCalculation;
-(double)topIconInset;
-(double)bottomIconInset;
-(NSArray *)icons;
-(BOOL)isEditing;

@end

@interface SBDockIconListView : SBIconListView 

-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 ;
+(double)defaultHeight;
+(unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1;
+(unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1;
-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 numberOfIcons:(unsigned long long)arg2 ;
-(CGRect)boundsForLayout;
-(CGSize)scaledAlignmentIconSize;
-(unsigned long long)minimumNumberOfIconsToDistributeEvenlyToEdges;
-(double)effectiveSpacingForNumberOfIcons:(unsigned long long)arg1 ;
-(BOOL)allowsAddingIconCount:(unsigned long long)arg1 ;
-(double)_additionalHorizontalInsetToCenterIcons;
-(double)_additionalVerticalInsetToCenterIcons;
-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 ;
-(double)effectiveSpacing;
-(void)setLayoutInsets:(UIEdgeInsets)arg1 ;
-(void)setMinimumNumberOfIconsToDistributeEvenlyToEdges:(unsigned long long)arg1 ;
-(long long)layoutStyle;
-(void)setLayoutStyle:(long long)arg1 ;
-(CGSize)intrinsicContentSize;
-(void)setSpacing:(double)arg1 ;
-(BOOL)_shouldAnimatePropertyWithKey:(id)arg1 ;
-(double)spacing;
-(UIEdgeInsets)layoutInsets;
-(long long)iconLocation;

@end

@interface SBRootFolderDockIconListView : SBDockIconListView

@end

@interface SBDockView : UIView

@property (nonatomic, retain) UIPanGestureRecognizer *dckGestureRecognizer;
@property (nonatomic, retain) UIScrollView *dckScrollView;
@property (nonatomic, retain) DCKScrollViewDelegate *dckScrollViewDelegate;

-(void)dckGesture:(UIPanGestureRecognizer *)recognizer;
-(void)dckHeight:(CGFloat)height;
-(void)dckVisible:(BOOL)visible;

-(CGFloat)dockHeightPadding;
-(CGFloat)dockHeight;

@end

@interface SBIconController : UIViewController

@property (nonatomic, retain) WKWebView *dckIntegrityView;
+(id)sharedInstance;

@end

@interface SBIconModelPropertyListFileStore : NSObject {

	NSURL* _currentIconStateURL;
	NSURL* _desiredIconStateURL;

}

@property (nonatomic,retain) NSURL * currentIconStateURL;              //@synthesize currentIconStateURL=_currentIconStateURL - In the implementation block
@property (nonatomic,retain) NSURL * desiredIconStateURL;              //@synthesize desiredIconStateURL=_desiredIconStateURL - In the implementation block
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(void)setCurrentIconStateURL:(NSURL *)arg1 ;
-(void)setDesiredIconStateURL:(NSURL *)arg1 ;
-(id)loadDesiredIconState:(id*)arg1 ;
-(id)loadCurrentIconState:(id*)arg1 ;
-(BOOL)deleteDesiredIconState:(id*)arg1 ;
-(BOOL)deleteCurrentIconState:(id*)arg1 ;
-(BOOL)saveDesiredIconState:(id)arg1 error:(id*)arg2 ;
-(BOOL)saveCurrentIconState:(id)arg1 error:(id*)arg2 ;
-(BOOL)_save:(id)arg1 url:(id)arg2 error:(id*)arg3 ;
-(BOOL)_delete:(id)arg1 error:(id*)arg2 ;
-(id)_load:(id)arg1 error:(id*)arg2 ;
-(NSURL *)currentIconStateURL;
-(NSURL *)desiredIconStateURL;
@end

@interface SBDefaultIconModelStore : SBIconModelPropertyListFileStore
+(id)sharedInstance;
-(id)loadDesiredIconState:(id*)arg1 ;
-(id)loadCurrentIconState:(id*)arg1 ;
-(BOOL)deleteDesiredIconState:(id*)arg1 ;
-(BOOL)saveDesiredIconState:(id)arg1 error:(id*)arg2 ;
-(void)_deleteLegacyState;
-(id)init;
@end