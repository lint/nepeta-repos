#import "CBDStepperView.h"

@implementation CBDStepperView

-(CBDStepperView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	self.titleLabel.text = @"STEPPER";
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.titleLabel];

	self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.valueLabel.font = [UIFont boldSystemFontOfSize:14];
	self.valueLabel.text = @"0";
	self.valueLabel.textColor = [UIColor whiteColor];
	self.valueLabel.textAlignment = NSTextAlignmentCenter;
	self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.valueLabel];

	self.stepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.stepper addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	self.stepper.translatesAutoresizingMaskIntoConstraints = NO;
	[self.stepper setTintColor:[UIColor whiteColor]];
	[self addSubview:self.stepper];

	[NSLayoutConstraint activateConstraints:@[
		[self.stepper.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.stepper.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
		[self.stepper.heightAnchor constraintEqualToConstant:30],
	]];

	[NSLayoutConstraint activateConstraints:@[
		[self.valueLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.valueLabel.trailingAnchor constraintEqualToAnchor:self.stepper.leadingAnchor constant:-5],
		[self.valueLabel.heightAnchor constraintEqualToConstant:30],
		[self.valueLabel.widthAnchor constraintEqualToConstant:45]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.valueLabel.leadingAnchor constant:-5],
		[self.titleLabel.heightAnchor constraintEqualToConstant:30]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[self.heightAnchor constraintEqualToConstant:50],
	]];
	
	return self;
}

-(NSString *)valueAsString {
	return [NSString stringWithFormat:@"%.f", self.stepper.value];
}

-(void)updateValue:(id)sender {
	self.valueLabel.text = [self valueAsString];
}

@end