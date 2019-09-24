#import "CBDContentViewMiscellaneous.h"
#import "CBDManager.h"

@implementation CBDContentViewMiscellaneous

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel.text = @"Miscellaneous";

	self.homescreenColumnsStepperView = [[CBDStepperView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.homescreenColumnsStepperView.stepper addTarget:self action:@selector(updateHomescreenColumns:) forControlEvents:UIControlEventValueChanged];
	self.homescreenColumnsStepperView.stepper.minimumValue = 0;
	self.homescreenColumnsStepperView.stepper.maximumValue = 8;
	self.homescreenColumnsStepperView.titleLabel.text = @"HOMESCREEN COLUMNS";
	[self.stackView addArrangedSubview:self.homescreenColumnsStepperView];

	self.homescreenRowsStepperView = [[CBDStepperView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.homescreenRowsStepperView.stepper addTarget:self action:@selector(updateHomescreenRows:) forControlEvents:UIControlEventValueChanged];
	self.homescreenRowsStepperView.stepper.minimumValue = 0;
	self.homescreenRowsStepperView.stepper.maximumValue = 8;
	self.homescreenRowsStepperView.titleLabel.text = @"HOMESCREEN ROWS";
	[self.stackView addArrangedSubview:self.homescreenRowsStepperView];

	self.hideIconLabelsSwitchView = [[CBDSwitchView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.hideIconLabelsSwitchView.theSwitch addTarget:self action:@selector(updateHideLabels:) forControlEvents:UIControlEventValueChanged];
	self.hideIconLabelsSwitchView.titleLabel.text = @"HIDE ICON LABELS";
	[self.stackView addArrangedSubview:self.hideIconLabelsSwitchView];

	[self refresh];

	return self;
}

-(void)refresh {
	self.homescreenColumnsStepperView.stepper.value = ([CBDManager sharedInstance].homescreenColumns == 0) ? 4 : [CBDManager sharedInstance].homescreenColumns;
	[self.homescreenColumnsStepperView updateValue:nil];

	self.homescreenRowsStepperView.stepper.value = ([CBDManager sharedInstance].homescreenRows == 0) ? 6 : [CBDManager sharedInstance].homescreenRows;
	[self.homescreenRowsStepperView updateValue:nil];

	self.hideIconLabelsSwitchView.theSwitch.on = [CBDManager sharedInstance].hideIconLabels;
}

-(void)updateHomescreenColumns:(id)sender {
	[CBDManager sharedInstance].homescreenColumns = self.homescreenColumnsStepperView.stepper.value;
	[[CBDManager sharedInstance] relayoutAllAnimated];
}

-(void)updateHomescreenRows:(id)sender {
	[CBDManager sharedInstance].homescreenRows = self.homescreenRowsStepperView.stepper.value;
	[[CBDManager sharedInstance] relayoutAllAnimated];
}

-(void)updateHideLabels:(id)sender {
	[CBDManager sharedInstance].hideIconLabels = self.hideIconLabelsSwitchView.theSwitch.on;
	[[CBDManager sharedInstance] relayoutAll];
}

@end