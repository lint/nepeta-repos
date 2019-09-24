#import "NTFSubPrefsListController.h"

@implementation NTFSubPrefsListController

- (id)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"NTFSub"];
    NSString *prefix = [@"NTF" stringByAppendingString:sub];
    NSString *title = [specifier name];

    if ([sub isEqualToString:@"Banners"]) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Notifications" target:self] retain];
    } else {
        _specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];
    }

    for (PSSpecifier *specifier in _specifiers) {
        NSString *key = [specifier propertyForKey:@"key"];
        if (key) {
            [specifier setProperty:[prefix stringByAppendingString:key] forKey:@"key"];
        }

        NSMutableDictionary *dict = [specifier propertyForKey:@"libcolorpicker"];
        if (dict) {
            dict[@"key"] = [prefix stringByAppendingString:dict[@"key"]];
            [specifier setProperty:dict forKey:@"libcolorpicker"];
        }

        if ([specifier.name isEqualToString:@"%SUB_NAME%"]) {
            specifier.name = title;
        }

        [self reloadSpecifier:specifier];
    }

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];
}

- (void)reloadSpecifiers {
    [self loadFromSpecifier:[self specifier]];
}

- (void)viewDidAppear:(bool)arg1 {
    [self reloadSpecifiers];
    [self reload];
}

@end