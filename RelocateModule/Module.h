
#import "RLCModuleViewController.h"
#import <ControlCenterUIKit/CCUIContentModule-Protocol.h>

@interface RLCToggleModule : NSObject <CCUIContentModule> {
    RLCModuleViewController *_contentViewController;
}

@property (nonatomic,readonly) UIViewController *backgroundViewController;

- (RLCModuleViewController *)contentViewController;

@end