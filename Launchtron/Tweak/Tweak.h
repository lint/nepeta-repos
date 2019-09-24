
@interface SBApplicationController : NSObject 

-(id)runningApplications;
+(id)_sharedInstanceCreateIfNecessary:(BOOL)arg1 ;
+(id)sharedInstance;
+(id)sharedInstanceIfExists;

@end

@interface SBApplication : NSObject

@property (nonatomic,readonly) NSString * bundleIdentifier;                                                                                         //@synthesize bundleIdentifier=_bundleIdentifier - In the implementation block

@end

@interface LTIconView : UIImageView

@property (nonatomic, retain) NSString* bundleIdentifier;

+(LTIconView *)iconWithBundleIdentifier:(NSString *)bundle;
-(void)handleTap;

@end

@interface LTWindow : UIWindow

@property (nonatomic, retain) UISwipeGestureRecognizer* upGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer* downGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGestureRecognizer;
@property (nonatomic, retain) CAGradientLayer* gradientLayer;
@property (nonatomic, assign) int iconOffset;
@property (nonatomic, assign) int currentSide;
@property (nonatomic, assign) bool isOpen;
@property (nonatomic, retain) NSArray* iconViews;
@property (nonatomic, assign) CGFloat originY;

-(void)setVisibility:(bool)state;
-(void)updateIcons;
-(void)handleTap;
-(void)setSide:(int)side;
-(void)gestureRecognized:(UIScreenEdgePanGestureRecognizer*)gesture;
-(CGRect)getEndingFrameForIcon:(LTIconView *)icon;
-(CGRect)getStartingFrameForIcon:(LTIconView *)icon;

@end

@interface LSApplicationWorkspace
- (bool)openApplicationWithBundleID:(id)arg1;
@end

@interface UIWindow(Launchtron)

@property (nonatomic, retain) UIScreenEdgePanGestureRecognizer* ltLeftGestureRecognizer;
@property (nonatomic, retain) UIScreenEdgePanGestureRecognizer* ltRightGestureRecognizer;

-(void)ltAddGestureRecognizer;
-(void)ltAddView;
-(void)ltEnable;
-(void)ltDisable;
-(void)ltSetSide:(bool)side;
-(void)ltGestureRecognized:(UIScreenEdgePanGestureRecognizer*)gesture;

@end

@interface UIImage(Launchtron)

+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3 ;

@end