#import "CBDView.h"

@interface SBRootIconListView : UIView

-(void)layoutIconsNow;

@end

@interface SBIconView : UIView

-(void)setLabelAccessoryViewHidden:(BOOL)arg1 ;

@end

@interface SBIconController : UIViewController

@property (nonatomic, strong) CBDView *cbdView;
+(id)sharedInstance;
-(BOOL)isEditing;
-(BOOL)relayout;
-(void)setIsEditing:(BOOL)arg1;
-(long long)currentIconListIndex;
-(SBRootIconListView *)rootIconListAtIndex:(long long)arg1 ;
-(NSTimer *)editingEndTimer;

@end

@interface UIStatusBarWindow : UIWindow

@end

@interface SBEditingDoneButton : UIView

@end