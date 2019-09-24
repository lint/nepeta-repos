#import "RLCModuleViewController.h"

@implementation RLCModuleViewController

-(id)init {
    self = [super init];
    
    self.preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.relocate"];
    [self.preferences registerPreferenceChangeBlock:^() {
        if ([self isExpanded]) {
            [self setSelected:NO];
        } else {
            [self setSelected:[([self.preferences objectForKey:@"Enabled"] ?: @(true)) boolValue]];
        }

        [self removeAllActions];

        id obj = [self.preferences objectForKey:@"Favorites"];
        if (obj && [obj isKindOfClass:[NSArray class]]) {
            NSArray *favorites = obj;
            __weak id weakSelf = self;
            __weak id weakPrefs = self.preferences;
            for (NSDictionary *favorite in favorites) {
                [self addActionWithTitle:favorite[@"Name"] glyph:((
                    [self.preferences objectForKey:@"SelectedFavorite"]
                    && [favorite[@"Name"] isEqualToString:[self.preferences objectForKey:@"SelectedFavorite"]]
                ) ? [self checkmarkGlyph] : [UIImage new]) handler:^() {
                    [weakSelf setSelected:YES];
                    [weakPrefs setBool:YES forKey:@"Enabled"];
                    [weakPrefs setBool:YES forKey:@"GlobalEnabled"];
                    [weakPrefs setObject:favorite[@"Name"] forKey:@"SelectedFavorite"];

                    NSMutableDictionary* globalLocation = [([weakPrefs objectForKey:@"GlobalLocation"] ?: @{}) mutableCopy];
                    globalLocation[@"Coordinate"] = @{
                        @"Latitude": favorite[@"Latitude"] ?: @(0),
                        @"Longitude": favorite[@"Longitude"] ?: @(0)
                    };
                    [weakPrefs setObject:globalLocation forKey:@"GlobalLocation"];
                    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.relocate/ReloadPrefs", nil, nil, true);
                }];
            }
        }
    }];

    return self;
}

- (UIImage *)checkmarkGlyph {
    return [UIImage imageNamed:@"Checkmark" inBundle:[NSBundle bundleForClass:[self class]]];
}

-(void)viewDidLayoutSubviews {
    if ([self isExpanded]) {
        [self setSelected:NO];
    } else {
        [self setSelected:[([self.preferences objectForKey:@"Enabled"] ?: @(true)) boolValue]];
    }

    [super viewDidLayoutSubviews];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setSelected:[([self.preferences objectForKey:@"Enabled"] ?: @(true)) boolValue]];
}

-(void)buttonTapped:(id)arg1 forEvent:(id)arg2 {
    BOOL newState = ![self isSelected];
    [self setSelected:newState];
    [self.preferences setBool:newState forKey:@"Enabled"];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.relocate/ReloadPrefs", nil, nil, true);
}

@end