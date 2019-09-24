#import "CBDContentView.h"
#import "CBDStepperView.h"
#import "CBDSwitchView.h"

@interface CBDContentViewMiscellaneous : CBDContentView

@property (nonatomic, strong) CBDStepperView *homescreenColumnsStepperView;
@property (nonatomic, strong) CBDStepperView *homescreenRowsStepperView;
@property (nonatomic, strong) CBDSwitchView *hideIconLabelsSwitchView;

@end