#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "NSTask.h"

#define COLORS_PATH @"/var/mobile/Library/Preferences/me.nepeta.nereid-colors.plist"
#define BUNDLE_ID @"me.nepeta.nereid"
#define TWEAK_NAME @"Nereid"

@interface NRDPrefsListController : HBRootListController
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
@end