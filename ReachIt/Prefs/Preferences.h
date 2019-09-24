#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "NSTask.h"

#define BUNDLE_ID @"me.nepeta.reachit"

@interface RITPrefsListController : HBRootListController
    - (void)resetPrefs:(id)sender;
    - (void)respring:(id)sender;
@end