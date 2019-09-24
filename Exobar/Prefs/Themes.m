#import "Themes.h"
#import "Preferences.h"

@interface UITableViewCell(Private)

-(UIView *)_accessoryView:(BOOL)x;

@end

@interface UILabel(Private)

-(CGFloat)_calculatedIntrinsicHeight;

@end

@interface EXBAlignedTableViewCell : UITableViewCell

@property (nonatomic, retain) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, assign) BOOL didUpdateConstraints;

-(void)updateImage:(UIImage *)image;

@end

#define MARGIN 5

@implementation EXBAlignedTableViewCell

-(void)layoutSubviews {
    [super layoutSubviews];
    UIView *accessoryView = [self _accessoryView:NO];
    accessoryView.frame = CGRectMake(self.frame.size.width - accessoryView.frame.size.width - 10.0,
                                        self.frame.size.height - 5.0 - [self.textLabel _calculatedIntrinsicHeight]/2.0 - [self.detailTextLabel _calculatedIntrinsicHeight]/2.0 - accessoryView.frame.size.height/2.0,
                                        accessoryView.frame.size.width, accessoryView.frame.size.height);
}

-(void)updateImage:(UIImage *)image {
    self.imageView.image = image;
    [self setNeedsLayout];
}

-(void)updateConstraints {
    if (!self.didUpdateConstraints) {
        self.didUpdateConstraints = YES;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5],
            [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:5],
            [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-5]
        ]];

        [NSLayoutConstraint activateConstraints:@[
            [self.textLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:5],
            [self.textLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
            [self.textLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        ]];

        [NSLayoutConstraint activateConstraints:@[
            [self.detailTextLabel.topAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor],
            [self.detailTextLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
            [self.detailTextLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
            [self.detailTextLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-5],
        ]];

        [NSLayoutConstraint activateConstraints:@[
            [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        ]];
    }
    
    if (self.imageHeightConstraint) {
        [NSLayoutConstraint deactivateConstraints:@[
            self.imageHeightConstraint
        ]];
    }

    CGFloat imageHeight = 0;

    if (self.imageView.image) {
        CGFloat ratio = (self.frame.size.width - 10)/self.imageView.image.size.width;
        imageHeight = self.imageView.image.size.height * ratio;
    }

    self.imageHeightConstraint = [self.imageView.heightAnchor constraintEqualToConstant:imageHeight];

    [NSLayoutConstraint activateConstraints:@[
        self.imageHeightConstraint
    ]];

    [super updateConstraints];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
    style = UITableViewCellStyleSubtitle;
    self = [super initWithStyle:style reuseIdentifier:identifier];
    self.didUpdateConstraints = NO;
    [self setNeedsUpdateConstraints];
    return self;
}

@end

@implementation EXBThemesListController

@synthesize themes = _themes;

- (BOOL)usesModernStatusBar {
    return [UIApplication sharedApplication].statusBarFrame.size.height > 40.0;
}

- (id)initForContentSize:(CGSize)size {
    self = [super init];

    if (self) {
        self.themes = [[NSMutableArray alloc] initWithCapacity:100];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setEditing:NO];
        [_tableView setAllowsSelection:YES];
        [_tableView setAllowsMultipleSelection:NO];
        [_tableView registerClass:[EXBAlignedTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsZero;

        if ([self respondsToSelector:@selector(setView:)])
            [self performSelectorOnMainThread:@selector(setView:) withObject:_tableView waitUntilDone:YES];        
    }

    return self;
}

- (void)addThemesFromDirectory:(NSString *)directory {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *diskThemes = [manager contentsOfDirectoryAtPath:directory error:nil];
    
    for (NSString *dirName in diskThemes) {
        EXBTheme *theme = [EXBTheme themeWithDirectoryName:dirName];
        
        if (theme) {
            //[theme preparePreviewImage];
            [self.themes addObject:theme];
        }
    }
}

- (void)refreshList {
    self.themes = [[NSMutableArray alloc] initWithCapacity:100];
    [self addThemesFromDirectory: EXBThemesDirectory];
            
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [self.themes sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];
    
    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:EXBPrefsIdentifier];
    selectedTheme = [([file objectForKey:@"Theme"] ?: @"Default") stringValue];
}

- (id)view {
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshList];
    [self setTitle:[self navigationTitle]];
    [self.navigationItem setTitle:[self navigationTitle]];
}

- (NSArray *)currentThemes {
    return self.themes;
}

- (void)dealloc { 
    self.themes = nil;
    [super dealloc];
}

- (NSString*)navigationTitle {
    return @"Themes";
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentThemes.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EXBAlignedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    EXBTheme *theme = [self.currentThemes objectAtIndex:indexPath.row];
    cell.textLabel.text = theme.name;
    cell.detailTextLabel.text = @"No additional information.";

    if (theme.info) {
        NSString *string = @"";
        if (theme.info[@"author"]) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"by %@ • ", theme.info[@"author"]]];
        }

        if (theme.info[@"version"]) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@ • ", theme.info[@"version"]]];
        }

        if ([string length] > 3) string = [string substringToIndex: [string length] - 3];

        if (theme.info[@"description"]) {
            if ([string length] > 0) string = [string stringByAppendingString:@"\n"];
            string = [string stringByAppendingString:theme.info[@"description"]];
        }

        cell.detailTextLabel.text = string;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.detailTextLabel setPreferredMaxLayoutWidth:tableView.frame.size.width - 40.0];
    }

    cell.layoutMargins = UIEdgeInsetsZero;
    [cell updateImage:[theme getPreviewImage:[self usesModernStatusBar]]];
    cell.selected = NO;

    if ([theme.name isEqualToString: selectedTheme] && !tableView.isEditing) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (!tableView.isEditing) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *old = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: [[self.currentThemes valueForKey:@"name"] indexOfObject: selectedTheme] inSection: 0]];
    if (old) old.accessoryType = UITableViewCellAccessoryNone;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    EXBTheme *theme = (EXBTheme*)[self.currentThemes objectAtIndex:indexPath.row];
    selectedTheme = theme.name;

    HBPreferences *file = [[HBPreferences alloc] initWithIdentifier:EXBPrefsIdentifier];
    [file setObject:selectedTheme forKey:@"Theme"];

    EXBPrefsListController *parent = (EXBPrefsListController *)self.parentController;
    [parent setThemeName:selectedTheme];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)EXBNotification, nil, nil, true);
}

@end
