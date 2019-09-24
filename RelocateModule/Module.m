#import "Module.h"

@implementation RLCToggleModule

-(id)init {
    self = [super init];
    _contentViewController = [[RLCModuleViewController alloc] init];
    _contentViewController.glyphImage = [self iconGlyph];
    _contentViewController.selectedGlyphColor = [self selectedColor];
    _contentViewController.title = @"Relocate";
    return self;
}

- (RLCModuleViewController *)contentViewController {
    return _contentViewController;
}

- (UIImage *)iconGlyph {
    return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
    return [UIColor blueColor];
}

@end