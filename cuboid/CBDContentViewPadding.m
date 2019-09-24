#import "CBDContentViewPadding.h"
#import "CBDManager.h"

@implementation CBDContentViewPadding

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel.text = @"Padding";

	self.verticalPaddingSliderView = [[CBDSliderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.verticalPaddingSliderView.titleLabel.text = @"VERTICAL PADDING";
	[self.verticalPaddingSliderView.slider addTarget:self action:@selector(updateVerticalPadding:) forControlEvents:UIControlEventValueChanged];
	self.verticalPaddingSliderView.slider.minimumValue = -200.0;
	self.verticalPaddingSliderView.slider.maximumValue = 200.0;
	self.verticalPaddingSliderView.slider.continuous = YES;
	[self.stackView addArrangedSubview:self.verticalPaddingSliderView];

	self.horizontalPaddingSliderView = [[CBDSliderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.horizontalPaddingSliderView.titleLabel.text = @"HORIZONTAL PADDING";
	[self.horizontalPaddingSliderView.slider addTarget:self action:@selector(updateHorizontalPadding:) forControlEvents:UIControlEventValueChanged];
	self.horizontalPaddingSliderView.slider.minimumValue = -200.0;
	self.horizontalPaddingSliderView.slider.maximumValue = 200.0;
	self.horizontalPaddingSliderView.slider.continuous = YES;
	[self.stackView addArrangedSubview:self.horizontalPaddingSliderView];

	[self refresh];

	return self;
}

-(void)refresh {
	self.verticalPaddingSliderView.slider.value = [CBDManager sharedInstance].verticalPadding;
	[self.verticalPaddingSliderView updateValue:nil];

	self.horizontalPaddingSliderView.slider.value = [CBDManager sharedInstance].horizontalPadding;
	[self.horizontalPaddingSliderView updateValue:nil];
}

-(void)updateVerticalPadding:(id)sender {
	[CBDManager sharedInstance].verticalPadding = self.verticalPaddingSliderView.slider.value;
	[[CBDManager sharedInstance] relayout];
}

-(void)updateHorizontalPadding:(id)sender {
	[CBDManager sharedInstance].horizontalPadding = self.horizontalPaddingSliderView.slider.value;
	[[CBDManager sharedInstance] relayout];
}

@end