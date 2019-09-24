#import "Module.h"
#import "../BCCommon.h"

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation BCToggleModule
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
	return [UIColor redColor];
}

- (BOOL)isSelected {
    return BCGetState();
}

- (void)setSelected:(BOOL)selected {
    BCSetState(selected);
	[super refreshState];
}
@end