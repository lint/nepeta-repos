#import "Preferences.h"

@implementation DCKAppearanceSettings

-(UIColor *)tintColor {
    return THEME_COLOR;
}

-(UIColor *)statusBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)tableViewCellSeparatorColor {
    return [UIColor colorWithWhite:0 alpha:0];
}

-(UIColor *)navigationBarBackgroundColor {
    return THEME_COLOR;
}

-(BOOL)translucentNavigationBar {
    return NO;
}

@end