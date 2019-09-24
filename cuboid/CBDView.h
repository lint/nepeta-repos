#import "CBDContentView.h"

@interface CBDView : UIView

@property (nonatomic, assign) BOOL presented;
@property (nonatomic, strong) UIVisualEffectView* blurView;
@property (nonatomic, strong) NSLayoutConstraint* heightConstraint;

@property (nonatomic, strong) CBDContentView* contentViewMain;
@property (nonatomic, strong) CBDContentView* contentViewOffset;
@property (nonatomic, strong) CBDContentView* contentViewPadding;
@property (nonatomic, strong) CBDContentView* contentViewMiscellaneous;
@property (nonatomic, strong) CBDContentView* contentViewSettings;

@property (nonatomic, weak) CBDContentView* contentViewPresented;

-(void)presentView:(CBDContentView*)view;
-(void)createView:(NSString*)key ofClass:(Class)theClass;

@end