#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "NSTask.h"

#define COLORS_PATH @"/var/mobile/Library/Preferences/me.nepeta.flashyhud-colors.plist"
#define BUNDLE_ID @"me.nepeta.flashyhud"
#define TWEAK_NAME @"FlashyHUD"

@interface FLHPrefsListController : HBRootListController
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
    - (void)saveSettings:(id)sender;
    - (void)shareSettings:(id)sender;
    - (void)importSettings:(id)sender;
    - (void)addDictionaryToSavedSettings:(NSDictionary *)dictionary;
    - (void)restoreSettingsFromDictionary:(NSDictionary*)settings;
    - (void)removeSavedSettingsAtIndex:(int)i;
    - (void)renameSavedSettingsAtIndex:(int)i name:(NSString*)name;
    - (NSDictionary*)dictionaryWithCurrentSettingsAndName:(NSString*)name;
    - (NSString*)serializeDictionary:(NSDictionary *)dictionary;
    - (NSDictionary*)deserializeDictionary:(NSString *)string;
@end