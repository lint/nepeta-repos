#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>

@interface FLHSavedSettingsListController : PSViewController <UITableViewDelegate,UITableViewDataSource> {
    UITableView *_tableView;
}

    @property (nonatomic, retain) UIBarButtonItem *importButton;
    @property (nonatomic, retain) NSMutableArray *savedSettings;
    @property (nonatomic, retain) NSString *selectedSettings;
    - (void)refreshList;
@end