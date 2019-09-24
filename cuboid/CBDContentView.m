#import "CBDContentView.h"
#import "CBDManager.h"

@implementation CBDContentView

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:25];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.text = @"Cuboid";
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.titleLabel];

	[NSLayoutConstraint activateConstraints:@[
		[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.titleLabel.heightAnchor constraintEqualToConstant:35]
	]];

	self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	[self.backButton setTitle:@"Back" forState:UIControlStateNormal];
	self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.backButton];

	[NSLayoutConstraint activateConstraints:@[
		[self.backButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
		[self.backButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.backButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.backButton.heightAnchor constraintEqualToConstant:35]
	]];

	self.stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.stackView.axis = UILayoutConstraintAxisVertical;
	self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
	self.stackView.distribution = UIStackViewDistributionEqualSpacing;
	[self addSubview:self.stackView];

	[NSLayoutConstraint activateConstraints:@[
		[self.stackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10],
		[self.stackView.bottomAnchor constraintEqualToAnchor:self.backButton.topAnchor constant:-10],
		[self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
		[self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
	]];
	
	return self;
}

-(void)back:(id)sender {
	[[CBDManager sharedInstance].view presentView:[CBDManager sharedInstance].view.contentViewMain];
	[[CBDManager sharedInstance] save];
}

-(void)refresh {

}

@end