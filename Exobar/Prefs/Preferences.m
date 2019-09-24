#import "Preferences.h"

@implementation EXBPrefsListController
- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;
        self.cellTypes = @{
            @"PSGroupCell": @(0),
            @"PSLinkCell": @(1),
            @"PSLinkListCell": @(2),
            @"PSListItemCell": @(3),
            @"PSTitleValueCell": @(4),
            @"PSSliderCell": @(5),
            @"PSSwitchCell": @(6),
            @"PSStaticTextCell": @(7),
            @"PSEditTextCell": @(8),
            @"PSSegmentCell": @(9),
            @"PSGiantIconCell": @(10),
            @"PSGiantCell": @(11),
            @"PSSecureEditTextCell": @(12),
            @"PSButtonCell": @(13),
            @"PSEditTextViewCell": @(14)
        };
    }

    return self;
}

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Prefs" target:self] retain];
    }
    return _specifiers;
}

- (void)addThemeSpecifiers {
    NSString *themeName = @"default";
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:EXBPrefsIdentifier];
    if ([prefs objectForKey:@"Theme"]) {
        themeName = [prefs objectForKey:@"Theme"];
    }

    EXBTheme *theme = [EXBTheme themeWithDirectoryName:themeName];
    if (!theme || !theme.info || !theme.info[@"settings"] || ![theme.info[@"settings"] isKindOfClass:[NSArray class]]) return;

    NSArray *settings = theme.info[@"settings"];
    if ([settings count] == 0) return;

    PSSpecifier *themeSettingsSpecifier = [self specifierForID:@"themeSettings"];
    [themeSettingsSpecifier setProperty:@"" forKey:@"footerText"];
    [self reloadSpecifier:themeSettingsSpecifier];

    for (int i = [settings count] - 1; i >= 0; i--) {
        NSDictionary *setting = settings[i];
        if (!setting || !setting[@"label"] || !setting[@"cell"] || ![self.cellTypes objectForKey:setting[@"cell"]]) continue;
        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:setting[@"label"] target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:[_cellTypes[setting[@"cell"]] longValue] edit:nil];
        if (!specifier) continue;

        if (setting[@"key"]) [specifier setProperty:[NSString stringWithFormat:@"TS%@%@", theme.name, setting[@"key"]] forKey:@"key"];
        [specifier setProperty:EXBPrefsIdentifier forKey:@"defaults"];
        [specifier setProperty:EXBNotification forKey:@"PostNotification"];
        for (NSString *key in setting) {
            if ([key isEqualToString:@"key"] || [key isEqualToString:@"label"]) continue;
            if ([key isEqualToString:@"cellClass"]) {
                [specifier setProperty:NSClassFromString(setting[key]) forKey:key];
                continue;
            }
            [specifier setProperty:setting[key] forKey:key];
        }

        [self insertSpecifier:specifier afterSpecifierID:@"themeSettings" animated:NO];
    }
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];
    [self addThemeSpecifiers];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self reloadSpecifiers];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;
	
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.translucent = YES;
}

- (void)refresh:(id)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)EXBRefreshNotification, nil, nil, true);
}

- (void)resetPrefs:(id)sender {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:EXBPrefsIdentifier];
    [prefs removeAllObjects];

    [self respring:sender];
}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)setThemeName:(NSString *)name {
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:[self indexPathForIndex:[self indexOfSpecifierID:@"theme"]]];
	cell.detailTextLabel.text = name;
    [self reloadSpecifiers];
}

@end