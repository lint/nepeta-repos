#import "Preferences.h"
#import "SavedSettings.h"

@implementation NTFPrefsListController
@synthesize respringButton;

- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(respring:)];
        self.respringButton.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem = self.respringButton;
    }

    return self;
}

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Prefs" target:self] retain];
    }
    return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;
	
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.translucent = YES;
}

- (void)testNotifications:(id)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.notifica/TestNotifications", nil, nil, true);
}

- (void)testBanner:(id)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.notifica/TestBanner", nil, nil, true);
}

- (void)resetPrefs:(id)sender {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    for (NSString *key in [prefs dictionaryRepresentation]) {
        if ([key isEqualToString:@"SavedSettings"] || [key isEqualToString:@"SelectedSettings"]) continue;
        [prefs removeObjectForKey:key];
    }

    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:COLORS_PATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:COLORS_PATH error:&error];
    }

    [self respring:sender];
}

- (void)respring:(id)sender {
    NSTask *t = [[[NSTask alloc] init] autorelease];
    [t setLaunchPath:@"/usr/bin/killall"];
    [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [t launch];
}

-(void)removeSavedSettingsAtIndex:(int)i {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    
    NSMutableArray *savedSettings = nil;

    if ([prefs objectForKey:@"SavedSettings"]) {
        savedSettings = [[prefs objectForKey:@"SavedSettings"] mutableCopy];
        [savedSettings removeObjectAtIndex:i];
    } else {
        savedSettings = [@[] mutableCopy];
    }

    [prefs setObject:savedSettings forKey:@"SavedSettings"];
}

-(void)renameSavedSettingsAtIndex:(int)i name:(NSString*)name {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    
    NSMutableArray *savedSettings = nil;

    if ([prefs objectForKey:@"SavedSettings"]) {
        savedSettings = [[prefs objectForKey:@"SavedSettings"] mutableCopy];
        NSMutableDictionary *dictionary = [savedSettings[i] mutableCopy];
        dictionary[@"name"] = name;
        savedSettings[i] = dictionary;
    } else {
        savedSettings = [@[] mutableCopy];
    }

    [prefs setObject:savedSettings forKey:@"SavedSettings"];
}

-(NSDictionary*)dictionaryWithCurrentSettingsAndName:(NSString*)name {
    NSMutableDictionary *settingsToSave = [NSMutableDictionary new];

    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];

    settingsToSave[@"name"] = name;

    settingsToSave[@"prefs"] = [NSMutableDictionary new];
    for (NSString *key in [prefs dictionaryRepresentation]) {
        if ([key isEqualToString:@"SavedSettings"] || [key isEqualToString:@"SelectedSettings"]) continue;
        settingsToSave[@"prefs"][key] = [prefs objectForKey:key];
    }

    NSDictionary *colors = [[NSDictionary alloc] initWithContentsOfFile:COLORS_PATH];
    if (colors) {
        settingsToSave[@"colors"] = colors;
    }

    return settingsToSave;
}

-(NSString*)serializeDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutable = [dictionary mutableCopy];
    mutable[@"id"] = BUNDLE_ID;

    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:mutable
                  format:NSPropertyListBinaryFormat_v1_0
                 options:kNilOptions
                   error:NULL];
    return [plist base64EncodedStringWithOptions:kNilOptions];
}

-(NSDictionary*)deserializeDictionary:(NSString *)string {
    NSData *plist = [[NSData alloc] initWithBase64EncodedString:string options:kNilOptions];
    if (!plist) return nil;
    
    return [NSPropertyListSerialization propertyListWithData:plist
                 options:kNilOptions
                  format:NULL
                   error:NULL];
}

-(void)copyX:(NSString *)x toY:(NSString *)y {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    for (NSString *key in [file dictionaryRepresentation]) {
        if (![key hasPrefix:y]) continue;
        [file removeObjectForKey:key];
    }

    for (NSString *key in [file dictionaryRepresentation]) {
        if (![key hasPrefix:x]) continue;
        [file setObject:[file objectForKey:key] forKey:[key stringByReplacingOccurrencesOfString:x withString:y]];
    }

    [file synchronize];

    NSMutableDictionary *colors = [[[NSDictionary alloc] initWithContentsOfFile:COLORS_PATH] mutableCopy];
    for (NSString *key in colors) {
        if (![key hasPrefix:y]) continue;
        [colors removeObjectForKey:key];
    }

    for (NSString *key in colors) {
        if (![key hasPrefix:x]) continue;
        colors[[key stringByReplacingOccurrencesOfString:x withString:y]] = colors[key];
    }

    [colors writeToFile:COLORS_PATH atomically:YES];
    [self reloadSpecifiers];
    [self reload];

    UIAlertController* savedAlert = [UIAlertController alertControllerWithTitle:TWEAK_NAME
                                message:@"Saved!\n\nYou may have to respring for the settings to show up, I don't know why it's like that, don't report that to me, cya."
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {}];
    [savedAlert addAction:defaultAction];
    [self presentViewController:savedAlert animated:YES completion:nil];
}

-(void)copyNtoB:(id)sender {
    [self copyX:@"NTFNotifications" toY:@"NTFBanners"];
}

-(void)copyBtoN:(id)sender {
    [self copyX:@"NTFBanners" toY:@"NTFNotifications"];
}

-(void)restoreSettingsFromDictionary:(NSDictionary *)settings {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    for (NSString *key in [file dictionaryRepresentation]) {
        if ([key isEqualToString:@"SavedSettings"] || [key isEqualToString:@"SelectedSettings"]) continue;
        [file removeObjectForKey:key];
    }

    for (NSString *key in settings[@"prefs"]) {
        if ([key isEqualToString:@"SavedSettings"] || [key isEqualToString:@"SelectedSettings"]) continue;
        [file setObject:settings[@"prefs"][key] forKey:key];
    }

    [file setObject:settings[@"name"] forKey:@"SelectedSettings"];

    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:COLORS_PATH]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:COLORS_PATH error:&error];
        if (success && settings[@"colors"]) {
            [settings[@"colors"] writeToFile:COLORS_PATH atomically:YES];
        }
    }
}

-(void)addDictionaryToSavedSettings:(NSDictionary *)dictionary {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];

    NSMutableArray *savedSettings = nil;
    if ([prefs objectForKey:@"SavedSettings"]) {
        savedSettings = [[prefs objectForKey:@"SavedSettings"] mutableCopy];
    } else {
        savedSettings = [@[] mutableCopy];
    }

    NSMutableDictionary *mutable = [dictionary mutableCopy];
    [mutable removeObjectForKey:@"id"];

    [savedSettings addObject:mutable];
    [prefs setObject:savedSettings forKey:@"SavedSettings"];
}

-(void)shareSettings:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:TWEAK_NAME
        message:@"Enter name"
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
            NSString *name = [(UITextField *)alert.textFields[0] text];

            NSArray *items = @[[self serializeDictionary:[self dictionaryWithCurrentSettingsAndName:name]]];

            UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];

            [self presentViewController:controller animated:YES completion:nil];

            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)importSettings:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:TWEAK_NAME
        message:@"Enter data"
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
            NSDictionary *dictionary = [self deserializeDictionary:[(UITextField *)alert.textFields[0] text]];
            bool comesFromList = [sender isKindOfClass:[NTFSavedSettingsListController class]];
            
            NSString *info = nil;
            if (!dictionary) {
                info = @"Couldn't import this preset - text seems incomplete. Check if you've selected and copied the entire string.";
            } else if (![dictionary isKindOfClass:[NSDictionary class]] || !dictionary[@"name"] || !dictionary[@"prefs"]) {
                info = @"Couldn't import this preset - dictionary is malformed.";
            } else if (dictionary[@"id"] && ![dictionary[@"id"] isEqualToString:BUNDLE_ID]) {
                info = [NSString stringWithFormat:@"Couldn't import this preset - this preset is for another tweak (%@).", dictionary[@"id"]];
            } else {
                [self addDictionaryToSavedSettings:dictionary];
                if (comesFromList) {
                    info = [NSString stringWithFormat:@"Imported preset: %@!\nTo activate this preset, select it.", dictionary[@"name"]];
                } else {
                    info = [NSString stringWithFormat:@"Imported preset: %@!\nTo activate this preset, go to \"Saved settings\" and select it.", dictionary[@"name"]];
                }
            }

            UIAlertController* savedAlert = [UIAlertController alertControllerWithTitle:TWEAK_NAME
                                        message:info
                                        preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
            [savedAlert addAction:defaultAction];
            [self presentViewController:savedAlert animated:YES completion:nil];

            if (comesFromList) [(NTFSavedSettingsListController*)sender refreshList];

            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"data";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)saveSettings:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:TWEAK_NAME
        message:@"Enter name"
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
            NSString *name = [(UITextField *)alert.textFields[0] text];

            [self addDictionaryToSavedSettings:[self dictionaryWithCurrentSettingsAndName:name]];

            UIAlertController* savedAlert = [UIAlertController alertControllerWithTitle:TWEAK_NAME
                                        message:@"Saved!"
                                        preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
            [savedAlert addAction:defaultAction];
            [self presentViewController:savedAlert animated:YES completion:nil];

            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];

    [alert addAction:ok];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];

    [self presentViewController:alert animated:YES completion:nil];
}
@end