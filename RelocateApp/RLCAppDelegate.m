#import "RLCAppDelegate.h"

@implementation RLCAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    /* Just replace the path to your pref bundle and you should be ok. */
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/RelocatePrefs.bundle"];
    [bundle load];
    if ([bundle isLoaded]) {
        _rootViewController = [[UINavigationController alloc] initWithRootViewController:[bundle.principalClass new]];
    } else {
        UIViewController *blank = [[UIViewController alloc] init];
        [[_rootViewController view] setBackgroundColor:[UIColor whiteColor]];
        _rootViewController = [[UINavigationController alloc] initWithRootViewController:blank];
    }
    _window.rootViewController = _rootViewController;
    [_window makeKeyAndVisible];
}

- (void)dealloc {
    [_window release];
    [_rootViewController release];
    [super dealloc];
}

@end
