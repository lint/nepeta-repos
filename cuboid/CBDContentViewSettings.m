#import "CBDContentViewSettings.h"
#import "CBDManager.h"

@implementation CBDContentViewSettings

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel.text = @"Save / Restore";

	[self.stackView removeFromSuperview];
	self.stackView.axis = UILayoutConstraintAxisHorizontal;
	self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
	self.stackView.distribution = UIStackViewDistributionFillEqually;
	[self addSubview:self.stackView];

	[NSLayoutConstraint activateConstraints:@[
		[self.stackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10],
		[self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
		[self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
		[self.stackView.heightAnchor constraintEqualToConstant:50],
	]];

	self.removeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.removeAllButton addTarget:self action:@selector(removeAll:) forControlEvents:UIControlEventTouchUpInside];
	[self.removeAllButton setTitle:@"Remove All" forState:UIControlStateNormal];
	[self.removeAllButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.removeAllButton];

	self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
	[self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
	[self.resetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.resetButton];

	self.showButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.showButton addTarget:self action:@selector(showCurrentSettings:) forControlEvents:UIControlEventTouchUpInside];
	[self.showButton setTitle:@"Show" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.showButton];

	self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
	[self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.saveButton];

	self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView setEditing:NO];
	[self.tableView setAllowsSelection:YES];
	[self.tableView setAllowsMultipleSelection:NO];
	self.tableView.estimatedRowHeight = 100;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.layoutMargins = UIEdgeInsetsZero;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	self.tableView.backgroundColor = [UIColor clearColor];
	[self addSubview:self.tableView];

	self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,1)];

	self.listEmptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,50)];
	self.listEmptyLabel.text = @"You have no saved settings.";
	self.listEmptyLabel.textColor = [UIColor whiteColor];
	self.listEmptyLabel.textAlignment = NSTextAlignmentCenter;
	self.listEmptyLabel.numberOfLines = 0;
	self.listEmptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.listEmptyLabel.font = [self.listEmptyLabel.font fontWithSize:14];

	self.tableView.tableFooterView = self.listEmptyLabel;

	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

	[NSLayoutConstraint activateConstraints:@[
		[self.tableView.topAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:10],
		[self.tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
		[self.tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
		[self.tableView.bottomAnchor constraintEqualToAnchor:self.backButton.topAnchor constant:-10],
	]];

	[self refresh];

	return self;
}

-(void)refresh {
	if ([[[CBDManager sharedInstance] savedLayouts] count] > 0) {
		self.tableView.tableFooterView = self.emptyView;
	} else {
		self.tableView.tableFooterView = self.listEmptyLabel;
	}

	[self.tableView reloadData];
}

-(void)save:(id)sender {
	UIAlertController *inputController = [UIAlertController
	alertControllerWithTitle:@"Name your layout"
	message:@""
	preferredStyle:UIAlertControllerStyleAlert];

	[inputController addTextFieldWithConfigurationHandler:^(UITextField *textField) {}];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
	handler:^(UIAlertAction *action) {
		if ([inputController textFields][0].text) {
			[[CBDManager sharedInstance] saveLayoutWithName:[inputController textFields][0].text];
			[self refresh];
		}
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	handler:^(UIAlertAction *action) {
	}];

	[inputController addAction:confirmAction];
	[inputController addAction:cancelAction];
	[[CBDManager sharedInstance] presentViewController:inputController animated:YES completion:NULL];
}

-(void)reset:(id)sender {
	UIAlertController *inputController = [UIAlertController
	alertControllerWithTitle:@"Are you sure?"
	message:@"Are you sure you want to reset your settings?"
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Reset settings" style:UIAlertActionStyleDefault
	handler:^(UIAlertAction *action) {
		[[CBDManager sharedInstance] reset];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	handler:^(UIAlertAction *action) {
	}];

	[inputController addAction:confirmAction];
	[inputController addAction:cancelAction];
	[[CBDManager sharedInstance] presentViewController:inputController animated:YES completion:NULL];
}

-(void)removeAll:(id)sender {
	UIAlertController *inputController = [UIAlertController
	alertControllerWithTitle:@"Are you sure?"
	message:@"Are you sure you want to remove all layouts?"
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Remove all" style:UIAlertActionStyleDefault
	handler:^(UIAlertAction *action) {
		[[CBDManager sharedInstance] deleteAllLayouts];
		[self refresh];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	handler:^(UIAlertAction *action) {
	}];

	[inputController addAction:confirmAction];
	[inputController addAction:cancelAction];
	[[CBDManager sharedInstance] presentViewController:inputController animated:YES completion:NULL];
}

-(void)showCurrentSettings:(id)sender {
	[self showLayout:[[CBDManager sharedInstance] currentSettingsAsDictionary]];
}

-(void)showLayout:(NSDictionary *)layout {
	UIAlertController *inputController = [UIAlertController
	alertControllerWithTitle:@"Layout"
	message:[[CBDManager sharedInstance] layoutDescription:layout]
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
	handler:^(UIAlertAction *action) {}];

	[inputController addAction:confirmAction];
	[[CBDManager sharedInstance] presentViewController:inputController animated:YES completion:NULL];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[CBDManager sharedInstance] savedLayouts] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	NSString *key = [[[[CBDManager sharedInstance] savedLayouts] allKeys] objectAtIndex:indexPath.row];
	
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.text = key;

	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *key = [[[[CBDManager sharedInstance] savedLayouts] allKeys] objectAtIndex:indexPath.row];
	UIAlertController *inputController = [UIAlertController
	alertControllerWithTitle:@"Are you sure?"
	message:[NSString stringWithFormat:@"Are you sure you want to restore saved layout \"%@\"?", key]
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Restore" style:UIAlertActionStyleDefault
	handler:^(UIAlertAction *action) {
		[[CBDManager sharedInstance] loadLayoutWithName:key];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	handler:^(UIAlertAction *action) {
	}];

	[inputController addAction:confirmAction];
	[inputController addAction:cancelAction];
	[[CBDManager sharedInstance] presentViewController:inputController animated:YES completion:NULL];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *key = [[[[CBDManager sharedInstance] savedLayouts] allKeys] objectAtIndex:indexPath.row];

	UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Rename" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {  
		UIAlertController *inputController = [UIAlertController
		alertControllerWithTitle:@"Name your layout"
		message:@""
		preferredStyle:UIAlertControllerStyleAlert];

		[inputController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
			textField.placeholder = key;
			textField.text = key;
		}];

		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault
		handler:^(UIAlertAction *action) {
			if ([inputController textFields][0].text) {
				[[CBDManager sharedInstance] renameLayoutWithName:key toName:[inputController textFields][0].text];
				[self refresh];
			}
		}];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction *action) {
		}];

		[inputController addAction:confirmAction];
		[inputController addAction:cancelAction];
		[[CBDManager sharedInstance] presentViewController:inputController animated:YES completion:NULL];
	}];
	renameAction.backgroundColor = [UIColor colorWithRed:0.27 green:0.47 blue:0.56 alpha:1.0];

	UITableViewRowAction *showAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Show" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {  
		[self showLayout:[CBDManager sharedInstance].savedLayouts[key]];
	}];
	showAction.backgroundColor = [UIColor colorWithRed:0.27 green:0.70 blue:0.56 alpha:1.0];

	UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
		[[CBDManager sharedInstance] deleteLayoutWithName:key];
		[self refresh];
	}];
	deleteAction.backgroundColor = [UIColor redColor];

	return @[deleteAction, showAction, renameAction];
}

@end