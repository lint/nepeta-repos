#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>

@interface MXIPrefsListController : HBRootListController
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
@end