#import "Preferences.h"

@implementation OwOPrefsListController
@synthesize respringButton;

- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        self.hb_appearanceSettings = appearanceSettings;
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"OwO" 
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
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.owo/TestNotifications", nil, nil, true);
}

- (void)testBanner:(id)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"me.nepeta.owo/TestBanner", nil, nil, true);
}

- (void)resetPrefs:(id)sender {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.owo"];
    [prefs removeAllObjects];
    
    [self respring:sender];
}

- (void)respring:(id)sender {
    NSTask *t = [[[NSTask alloc] init] autorelease];
    [t setLaunchPath:@"/usr/bin/killall"];
    [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [t launch];
}
@end