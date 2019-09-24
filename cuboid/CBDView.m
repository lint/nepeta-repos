#import "CBDView.h"
#import "CBDManager.h"

#import "CBDContentViewMain.h"
#import "CBDContentViewOffset.h"
#import "CBDContentViewPadding.h"
#import "CBDContentViewMiscellaneous.h"
#import "CBDContentViewSettings.h"

@implementation CBDView

-(CBDView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.alpha = 0.0;

	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	self.blurView.frame = self.bounds;
	self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
	[self insertSubview:self.blurView atIndex:0];

	[NSLayoutConstraint activateConstraints:@[
		[self.blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
	]];

	[self createView:@"_contentViewMain" ofClass:[CBDContentViewMain class]];
	self.contentViewMain.alpha = 1.0;
	self.contentViewPresented = self.contentViewMain;

	[self createView:@"_contentViewOffset" ofClass:[CBDContentViewOffset class]];
	[self createView:@"_contentViewPadding" ofClass:[CBDContentViewPadding class]];
	[self createView:@"_contentViewMiscellaneous" ofClass:[CBDContentViewMiscellaneous class]];
	[self createView:@"_contentViewSettings" ofClass:[CBDContentViewSettings class]];

	return self;
}

-(void)createView:(NSString*)key ofClass:(Class)theClass {
	UIView *view = [[theClass alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	view.alpha = 0.0;
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self setValue:view forKey:key];
	[self addSubview:view];

	[NSLayoutConstraint activateConstraints:@[
		[view.topAnchor constraintEqualToAnchor:self.topAnchor constant:[UIApplication sharedApplication].statusBarFrame.size.height],
		[view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
	]];
}

-(void)presentView:(CBDContentView*)view {
	if (self.contentViewPresented == view) return;

	__weak CBDContentView *oldPresented = self.contentViewPresented;
	self.contentViewPresented = view;
	[self.contentViewPresented refresh];
	[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		if (oldPresented) oldPresented.alpha = 0.0;
		self.contentViewPresented.alpha = 1.0;
	} completion:nil];
}

-(void)setPresented:(BOOL)presented {
	if (_presented == presented) return;

	_presented = presented;
	if (presented) {
		[self.superview bringSubviewToFront:self];
		[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.alpha = 1.0;
			self.frame = CGRectMake(0, 0, self.frame.size.width, 300);
			[self layoutIfNeeded];
		} completion:NULL];
	} else {
		[[CBDManager sharedInstance] relayoutAllAnimated];
		[[CBDManager sharedInstance] save];
		[[CBDManager sharedInstance] stopEditing];
		[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.alpha = 0.0;
			self.frame = CGRectMake(0, 0, self.frame.size.width, 0);
			[self layoutIfNeeded];
		} completion:^(BOOL whatever) {
			[self presentView:self.contentViewMain];
		}];
	}
}

@end