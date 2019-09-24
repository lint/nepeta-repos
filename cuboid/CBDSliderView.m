#import "CBDSliderView.h"
#import "CBDManager.h"

@implementation CBDSliderView

+ (UIImage *)thumbImage {
    static UIImage *blueCircle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);

        CGRect rect = CGRectMake(0, 0, 20, 20);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillEllipseInRect(ctx, rect);

        CGContextRestoreGState(ctx);
        blueCircle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    });
    return blueCircle;
}

-(CBDSliderView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	self.titleLabel.text = @"SLIDER";
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.titleLabel];

	[NSLayoutConstraint activateConstraints:@[
		[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
		[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.titleLabel.heightAnchor constraintEqualToConstant:20]
	]];

	self.valueButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.valueButton addTarget:self action:@selector(editValue:) forControlEvents:UIControlEventTouchUpInside];
	[self.valueButton setTitle:@"0.0" forState:UIControlStateNormal];
	self.valueButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.valueButton.titleLabel.font = [UIFont systemFontOfSize:14];
	self.valueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:self.valueButton];

	[NSLayoutConstraint activateConstraints:@[
		[self.valueButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
		[self.valueButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.valueButton.heightAnchor constraintEqualToConstant:35],
		[self.valueButton.widthAnchor constraintEqualToConstant:45]
	]];

	self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.slider setThumbImage:[CBDSliderView thumbImage] forState:UIControlStateNormal];
	[self.slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	[self.slider addTarget:self action:@selector(touchDrag:) forControlEvents:UIControlEventTouchDragInside];
	[self.slider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	self.slider.translatesAutoresizingMaskIntoConstraints = NO;
	[self.slider setMinimumTrackTintColor:[UIColor whiteColor]];
	[self.slider setMaximumTrackTintColor:[UIColor blackColor]];
	[self addSubview:self.slider];

	[NSLayoutConstraint activateConstraints:@[
		[self.slider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],
		[self.slider.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
		[self.slider.trailingAnchor constraintEqualToAnchor:self.valueButton.leadingAnchor constant:-5],
		[self.slider.heightAnchor constraintEqualToConstant:35]
	]];

	[NSLayoutConstraint activateConstraints:@[
		[self.heightAnchor constraintEqualToConstant:70],
	]];
	
	return self;
}

-(NSString *)valueAsString {
	if (self.isInteger) return [NSString stringWithFormat:@"%.f", self.slider.value];
	return [NSString stringWithFormat:@"%.01f", self.slider.value];
}

-(void)updateValue:(id)sender {
	[self.valueButton setTitle:[self valueAsString] forState:UIControlStateNormal];
}

-(void)editValue:(id)sender {
	NSString *placeholder = [self valueAsString];
	
	UIAlertController *integerInputController = [UIAlertController
	alertControllerWithTitle:@"Edit value"
	message:@""
	preferredStyle:UIAlertControllerStyleAlert];

	[integerInputController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = placeholder;
		textField.text = placeholder;
	}];
	
	[[integerInputController textFields][0] setKeyboardType:UIKeyboardTypeNumberPad];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
	handler:^(UIAlertAction *action) {
		if ([integerInputController textFields][0].text) self.slider.value = [[integerInputController textFields][0].text intValue];
		[self.slider sendActionsForControlEvents:UIControlEventValueChanged];
	}];

	[integerInputController addAction:confirmAction];
	[[CBDManager sharedInstance] presentViewController:integerInputController animated:YES completion:NULL];
}

-(void)touchDrag:(id)sender {
	[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[[CBDManager sharedInstance] view].alpha = 0.3;
	} completion:nil];
}

-(void)touchUp:(id)sender {
	[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[[CBDManager sharedInstance] view].alpha = 1.0;
	} completion:nil];
}

@end