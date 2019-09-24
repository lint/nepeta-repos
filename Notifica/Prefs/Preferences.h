#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "NSTask.h"

#define COLORS_PATH @"/var/mobile/Library/Preferences/me.nepeta.notifica-colors.plist"
#define BUNDLE_ID @"me.nepeta.notifica"
#define TWEAK_NAME @"Notifica"

@interface NTFPrefsListController : HBRootListController
    @property (nonatomic, retain) UIBarButtonItem *respringButton;
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
    - (void)testNotifications:(id)sender;
    - (void)testBanner:(id)sender;
    - (void)saveSettings:(id)sender;
    - (void)shareSettings:(id)sender;
    - (void)importSettings:(id)sender;
    - (void)copyNtoB:(id)sender;
    - (void)copyBtoN:(id)sender;
    - (void)copyX:(NSString *)x toY:(NSString *)y;
    - (void)addDictionaryToSavedSettings:(NSDictionary *)dictionary;
    - (void)restoreSettingsFromDictionary:(NSDictionary*)settings;
    - (void)removeSavedSettingsAtIndex:(int)i;
    - (void)renameSavedSettingsAtIndex:(int)i name:(NSString*)name;
    - (NSDictionary*)dictionaryWithCurrentSettingsAndName:(NSString*)name;
    - (NSString*)serializeDictionary:(NSDictionary *)dictionary;
    - (NSDictionary*)deserializeDictionary:(NSString *)string;
@end