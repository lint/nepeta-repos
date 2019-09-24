#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>
#import "../EXBTheme.h"

@interface EXBPrefsListController : HBRootListController

@property (nonatomic, retain) NSDictionary *cellTypes;

    - (void)refresh:(id)sender;
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
    - (void)setThemeName:(NSString *)name;
    - (void)addThemeSpecifiers;
@end