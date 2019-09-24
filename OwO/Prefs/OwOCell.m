#import "OwOCell.h"
#import <Preferences/PSSpecifier.h>

@implementation OwOCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.backgroundView = nil;

		self.stringView = [[_UIGlintyStringView alloc] initWithText:@"OwO" andFont:[UIFont systemFontOfSize:40]];
		self.stringView.frame = self.contentView.bounds;
		self.stringView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:self.stringView];

        [self.stringView setChevronStyle:0];
        [self.stringView show];

		self.imageView.hidden = YES;
		self.textLabel.hidden = YES;
		self.detailTextLabel.hidden = YES;
	}

	return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}

- (void)willMoveToWindow:(id)window {
    [super layoutSubviews];
    [self.stringView show];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	return 150;
}

@end