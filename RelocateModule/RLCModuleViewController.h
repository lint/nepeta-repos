#import <ControlCenterUIKit/CCUIMenuModuleViewController.h>
#import <Cephei/HBPreferences.h>

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@interface RLCModuleViewController : CCUIMenuModuleViewController

@property (nonatomic, retain) HBPreferences *preferences;

-(void)buttonTapped:(id)arg1 forEvent:(id)arg2 ;

@end