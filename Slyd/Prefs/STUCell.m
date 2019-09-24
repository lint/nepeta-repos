#import "STUCell.h"
#import <Preferences/PSSpecifier.h>

@implementation STUCell {
	_UIGlintyStringView *_stringView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.backgroundView = nil;

		_stringView = [[_UIGlintyStringView alloc] initWithText:@"slide to unlock" andFont:[UIFont systemFontOfSize:25]];
		_stringView.frame = self.contentView.bounds;
		_stringView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_stringView];

        [_stringView setChevronStyle:1];
        [_stringView show];

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

#pragma mark - PSHeaderFooterView

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	return 150;
}

@end