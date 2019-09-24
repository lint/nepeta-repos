#import "CBDSwitchView.h"

@implementation CBDSwitchView

-(CBDSwitchView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	self.titleLabel.text = @"SWITCH";
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.titleLabel];

	self.theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.theSwitch.translatesAutoresizingMaskIntoConstraints = NO;
	[self.theSwitch setTintColor:[UIColor blackColor]];
	[self.theSwitch setOnTintColor:[UIColor blackColor]];
	[self addSubview:self.theSwitch];

	[NSLayoutConstraint activateConstraints:@[
		[self.theSwitch.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.theSwitch.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
		[self.theSwitch.heightAnchor constraintEqualToConstant:30],
	]];

	[NSLayoutConstraint activateConstraints:@[
		[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.theSwitch.leadingAnchor constant:-5],
		[self.titleLabel.heightAnchor constraintEqualToConstant:30]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[self.heightAnchor constraintEqualToConstant:50],
	]];
	
	return self;
}

@end