#import "CBDContentViewMain.h"
#import "CBDManager.h"

@implementation CBDContentViewMain

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.offsetSettingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.offsetSettingsButton addTarget:self action:@selector(presentOffset:) forControlEvents:UIControlEventTouchUpInside];
	[self.offsetSettingsButton setTitle:@"Offset" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.offsetSettingsButton];

	self.paddingSettingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.paddingSettingsButton addTarget:self action:@selector(presentPadding:) forControlEvents:UIControlEventTouchUpInside];
	[self.paddingSettingsButton setTitle:@"Padding" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.paddingSettingsButton];

	self.miscellaneousButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.miscellaneousButton addTarget:self action:@selector(presentMiscellaneous:) forControlEvents:UIControlEventTouchUpInside];
	[self.miscellaneousButton setTitle:@"Miscellaneous" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.miscellaneousButton];

	self.saveRestoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.saveRestoreButton addTarget:self action:@selector(presentSettings:) forControlEvents:UIControlEventTouchUpInside];
	[self.saveRestoreButton setTitle:@"Save / Restore" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.saveRestoreButton];

	[self.backButton setTitle:@"Done" forState:UIControlStateNormal];

	return self;
}

-(void)back:(id)sender {
	[[CBDManager sharedInstance].view setPresented:NO];
}

-(void)presentOffset:(id)sender {
	[[CBDManager sharedInstance].view presentView:[CBDManager sharedInstance].view.contentViewOffset];
}

-(void)presentPadding:(id)sender {
	[[CBDManager sharedInstance].view presentView:[CBDManager sharedInstance].view.contentViewPadding];
}

-(void)presentMiscellaneous:(id)sender {
	[[CBDManager sharedInstance].view presentView:[CBDManager sharedInstance].view.contentViewMiscellaneous];
}

-(void)presentSettings:(id)sender {
	[[CBDManager sharedInstance].view presentView:[CBDManager sharedInstance].view.contentViewSettings];
}

@end