#import "Sub.h"

@implementation FLHSubPrefsListController

- (id)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"FLHSub"];
    NSString *title = [specifier name];

    _specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];
}

- (bool)shouldReloadSpecifiersOnResume {
    return false;
}

@end