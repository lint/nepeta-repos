#import "SavedSettings.h"
#import "Preferences.h"

@implementation FLHSavedSettingsListController

- (id)initForContentSize:(CGSize)size {
    self = [super init];

    if (self) {
        self.savedSettings = [[NSMutableArray alloc] initWithCapacity:100];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setEditing:NO];
        [_tableView setAllowsSelection:YES];
        [_tableView setAllowsMultipleSelection:NO];
        
        self.importButton = [[UIBarButtonItem alloc] initWithTitle:@"Import" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(import:)];
        self.importButton.tintColor = [UIColor colorWithRed:0.11 green:0.33 blue:0.36 alpha:1.0];
        self.navigationItem.rightBarButtonItem = self.importButton;
        
        if ([self respondsToSelector:@selector(setView:)])
            [self performSelectorOnMainThread:@selector(setView:) withObject:_tableView waitUntilDone:YES];
    }

    return self;
}

- (void)import:(id)sender {
    FLHPrefsListController *parent = (FLHPrefsListController *)self.parentController;
    [parent importSettings:self];
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *title = [specifier name];
    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];
}

- (void)refreshList {
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    self.savedSettings = [file objectForKey:@"SavedSettings"];
    self.selectedSettings = [([file objectForKey:@"SelectedSettings"] ?: @"") stringValue];
    [_tableView reloadData];
}

- (id)view {
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self refreshList];
}

- (void)dealloc { 
    self.savedSettings = nil;
    [super dealloc];
}

- (NSString*)navigationTitle {
    return @"Saved settings";
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedSettings.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];
    }
    
    NSDictionary *settings = [self.savedSettings objectAtIndex:indexPath.row];
    cell.textLabel.text = settings[@"name"];    
    cell.selected = NO;

    /*if ([settings[@"name"] isEqualToString: self.selectedSettings] && !tableView.isEditing) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (!tableView.isEditing) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }*/

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *settings = (NSDictionary*)[self.savedSettings objectAtIndex:indexPath.row];

    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:TWEAK_NAME
        message:[NSString stringWithFormat:@"Are you sure you want to restore \"%@\" and respring?", settings[@"name"]]
        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
            NSDictionary *settings = (NSDictionary*)[self.savedSettings objectAtIndex:indexPath.row];

            FLHPrefsListController *parent = (FLHPrefsListController *)self.parentController;
            [parent restoreSettingsFromDictionary:settings];
            [parent respring:nil];
        }
    ];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
    ];

    [alert addAction:ok];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Rename" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSDictionary *settings = (NSDictionary*)[self.savedSettings objectAtIndex:indexPath.row];
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:TWEAK_NAME
            message:@"Enter name"
            preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action){
                FLHPrefsListController *parent = (FLHPrefsListController *)self.parentController;
                [parent renameSavedSettingsAtIndex:indexPath.row name:[alert.textFields[0] text]];
                [self refreshList];
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
            textField.text = settings[@"name"];
        }];

        [self presentViewController:alert animated:YES completion:nil];
    }];
    renameAction.backgroundColor = [UIColor colorWithRed:0.27 green:0.47 blue:0.56 alpha:1.0];

    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSDictionary *settings = (NSDictionary*)[self.savedSettings objectAtIndex:indexPath.row];
        FLHPrefsListController *parent = (FLHPrefsListController *)self.parentController;

        NSArray *items = @[[parent serializeDictionary:settings]];

        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
    }];
    shareAction.backgroundColor = [UIColor colorWithRed:0.11 green:0.33 blue:0.36 alpha:1.0];

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        FLHPrefsListController *parent = (FLHPrefsListController *)self.parentController;
        [parent removeSavedSettingsAtIndex:indexPath.row];
        [self refreshList];
    }];
    deleteAction.backgroundColor = [UIColor redColor];

    return @[deleteAction, shareAction, renameAction];
}

@end