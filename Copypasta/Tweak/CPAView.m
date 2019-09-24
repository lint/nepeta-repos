#import <AppList/AppList.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CPAView.h"
#import "CPAManager.h"
#import "CPAItem.h"
#import "Tweak.h"

@implementation UIImage (scale)

- (UIImage *)scaleImageToSize:(CGSize)newSize {
  
  CGRect scaledImageRect = CGRectZero;
  
  CGFloat aspectWidth = newSize.width / self.size.width;
  CGFloat aspectHeight = newSize.height / self.size.height;
  CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
  
  scaledImageRect.size.width = self.size.width * aspectRatio;
  scaledImageRect.size.height = self.size.height * aspectRatio;
  scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
  scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
  
  UIGraphicsBeginImageContextWithOptions( newSize, NO, 0 );
  [self drawInRect:scaledImageRect];
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return scaledImage;
  
}

@end

@implementation CPAView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    [self setUserInteractionEnabled:YES];

    self.icons = [NSMutableDictionary new];
    CGSize size = CGSizeMake(29, 29);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    self.placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.baseFrame = frame;
    self.hidden = YES;
    self.alpha = 0.0;

    self.wrapperView = [[UIView alloc] initWithFrame:frame];

    [self addSubview:self.wrapperView];

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
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,100)];

    self.listEmptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,100)];
    self.listEmptyLabel.text = @"There are no items in your list. Copy some text from other apps.";
    self.listEmptyLabel.textAlignment = NSTextAlignmentCenter;
    self.listEmptyLabel.numberOfLines = 0;
    self.listEmptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.listEmptyLabel.font = [self.listEmptyLabel.font fontWithSize:14];

    self.tableView.tableFooterView = self.emptyView;
    
    [self.wrapperView addSubview:self.tableView];

    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissButton.transform = CGAffineTransformMakeRotation(M_PI);
    self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    [self.dismissButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    self.dismissButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.dismissButton setTitle:NULL forState:UIControlStateNormal];
    [self.dismissButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CopypastaPrefs.bundle/chevron.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self addSubview:self.dismissButton];

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.wrapperView.topAnchor constant:0],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.wrapperView.leadingAnchor constant:5],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.wrapperView.trailingAnchor constant:-5],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.wrapperView.bottomAnchor constant:0]
    ]];

    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.dismissButton.heightAnchor constraintEqualToConstant:30],
        [self.dismissButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:5],
        [self.dismissButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-5],
        [self.dismissButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0]
    ]];

    self.wrapperView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.wrapperView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0],
        [self.wrapperView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0],
        [self.wrapperView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0],
        [self.wrapperView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0]
    ]];

    [self preloadIcons];

    return self;
}

-(void)refresh {
    self.wantsAnimations = YES;
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.tableView numberOfSections])];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];

    if (([[[CPAManager sharedInstance] favoriteItems] count] + [[[CPAManager sharedInstance] items] count]) == 0) {
        self.tableView.tableFooterView = self.listEmptyLabel;
    } else {
        self.tableView.tableFooterView = self.emptyView;
    }

    self.wantsAnimations = NO;
}

-(void)recreateBlur {
    [self.blurView removeFromSuperview];

    if (self.darkMode) {
        self.backgroundColor = [UIColor blackColor];
        self.dismissButton.tintColor = [UIColor whiteColor];
        self.listEmptyLabel.textColor = [UIColor whiteColor];
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.dismissButton.tintColor = [UIColor blackColor];
        self.listEmptyLabel.textColor = [UIColor blackColor];
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    }

    if (!self.useBlur) return;

    self.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(self.darkMode ? UIBlurEffectStyleDark : UIBlurEffectStyleLight)];
    
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.bounds;
    self.blurView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.60];
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.blurView atIndex:0];
}

-(void)setBaseFrame:(CGRect)frame {
    _baseFrame = frame;

    if (self.lastHeight > 0) {
        [self setHeight:self.lastHeight];
    }
    
    if (self.tableHeight > 0) {
        [self setTableHeight:self.tableHeight];
    }
}

-(void)setTableHeight:(CGFloat)height {
    _tableHeight = height;
    self.targetFrame = CGRectMake(self.baseFrame.origin.x, self.baseFrame.origin.y - height, self.baseFrame.size.width, height);
}

-(void)setHeight:(CGFloat)height {
    if (height >= 0) {
        self.lastHeight = height;
        self.frame = CGRectMake(self.baseFrame.origin.x, self.baseFrame.origin.y - height, self.baseFrame.size.width, height);
    }
}

-(void)show:(BOOL)fully animated:(BOOL)animated {
    if (self.isOpen && self.isOpenFully) return;

    self.wantsAnimations = animated;

    [self preloadIcons];
    self.isOpen = YES;
    self.isOpenFully = fully;
    [self setHidden: NO];
    [self.tableView setContentOffset:CGPointZero animated:YES];

    if (fully) {
        [self.tableView setHidden:NO];
        self.dismissButton.transform = CGAffineTransformMakeRotation(0);
        if (animated) {
            [self setHeight:0];

            if (self.alpha != 1.0) {
                self.alpha = 0.0;
            }

            [UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1.0;
                self.frame = self.targetFrame;
            } completion:NULL];
        } else {
            self.frame = self.targetFrame;
            self.alpha = 1.0;
        }
    } else {
        self.dismissButton.transform = CGAffineTransformMakeRotation(M_PI);

        if (animated) {
            self.alpha = 1.0;
            [self setHeight:0];

            [UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self setHeight:30];
            } completion:NULL];
            [self.tableView setHidden:YES];
        } else {
            [self setHeight:30];
            [self.tableView setHidden:YES];
            self.alpha = 1.0;
        }
    }

    self.wantsAnimations = NO;
}

-(void)hide:(BOOL)fully animated:(BOOL)animated {
    if (!self.isOpen) return;

    self.wantsAnimations = animated;
    self.isOpen = !fully;
    self.isOpenFully = NO;

    if (fully) {
        self.dismissButton.transform = CGAffineTransformMakeRotation(M_PI);
        if (animated) {
            self.alpha = 1.0;
            self.frame = self.targetFrame;

            [UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0.0;
                [self setHeight:0];
            } completion:NULL];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.15) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if (!self.isOpen) [self setHidden: YES];
                self.frame = self.targetFrame;
            });
        } else {
            self.alpha = 0.0;
            self.hidden = YES;
            [self setHeight:0];
        }
    } else {
        self.dismissButton.transform = CGAffineTransformMakeRotation(M_PI);
        [self.tableView setHidden:YES];
        if (animated) {
            [UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self setHeight:30];
            } completion:NULL];
        } else {
            [self setHeight:30];
        }
    }

    self.wantsAnimations = NO;
}

-(void)preloadIcons {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i = 0;
        for (CPAItem *item in [[CPAManager sharedInstance] items]) {
            if (!self.icons[item.bundleId]) {
                self.icons[item.bundleId] = [[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:item.bundleId] scaleImageToSize:CGSizeMake(29,29)];
            }
        }

        i = 0;
        for (CPAItem *item in [[CPAManager sharedInstance] favoriteItems]) {
            if (!self.icons[item.bundleId]) {
                self.icons[item.bundleId] = [[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:item.bundleId] scaleImageToSize:CGSizeMake(29,29)];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(void)toggle {
    if (self.playsHapticFeedback) AudioServicesPlaySystemSound(1519);

    if (self.isOpenFully) [self hide:self.dismissesFully animated:YES];
    else [self show:YES animated:YES];
}

-(void)cpaPaste:(NSString *)text {
    UIKeyboardImpl *impl = [NSClassFromString(@"UIKeyboardImpl") activeInstance];
    [impl insertText:text];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((section == 0) ? [[CPAManager sharedInstance] favoriteItems] : [[CPAManager sharedInstance] items]) count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    cell.backgroundColor = [UIColor clearColor];
    if (self.darkMode) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    CPAItem *item = nil;
    if (indexPath.section == 0) {
        item = [[[CPAManager sharedInstance] favoriteItems] objectAtIndex:indexPath.row];
        cell.textLabel.text = [@"★ " stringByAppendingString:item.title];
    } else {
        item = [[[CPAManager sharedInstance] items] objectAtIndex:indexPath.row];
        cell.textLabel.text = item.title;
    }

    if (self.showIcons) {
        cell.imageView.image = self.placeholderImage;
        if (self.icons[item.bundleId]) {
            cell.imageView.image = self.icons[item.bundleId];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.icons[item.bundleId] = [[[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:item.bundleId] scaleImageToSize:CGSizeMake(29,29)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell) updateCell.imageView.image = self.icons[item.bundleId];
                });
            });
        }
    } else {
        cell.imageView.image = nil;
    }
    
    cell.detailTextLabel.text = item.content;

    if (!self.showNames) {
        cell.textLabel.text = nil;
        if (indexPath.section == 0) {
            cell.detailTextLabel.text = [@"★ " stringByAppendingString:item.content];
        }
    }

    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.detailTextLabel setPreferredMaxLayoutWidth:tableView.frame.size.width - 40.0];
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selected = NO;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.playsHapticFeedback) AudioServicesPlaySystemSound(1519);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CPAItem *item = nil;
    if (indexPath.section == 0) {
        item = [[[CPAManager sharedInstance] favoriteItems] objectAtIndex:indexPath.row];
    } else {
        item = [[[CPAManager sharedInstance] items] objectAtIndex:indexPath.row];
    }
    [self cpaPaste:item.content];
    if (self.dismissAfterPaste) [self hide:self.dismissesFully animated:YES];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *favoriteAction = nil;

    if (indexPath.section == 1) {
        favoriteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Favorite" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {    
            CPAItem *item = nil;
            if (indexPath.section == 1) {
                item = [[[CPAManager sharedInstance] items] objectAtIndex:indexPath.row];
            }

            if (item) [[CPAManager sharedInstance] favoriteItem:item];
        }];
        favoriteAction.backgroundColor = [UIColor colorWithRed:0.27 green:0.47 blue:0.56 alpha:1.0];
    }

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        CPAItem *item = nil;
        if (indexPath.section == 0) {
            item = [[[CPAManager sharedInstance] favoriteItems] objectAtIndex:indexPath.row];
        } else {
            item = [[[CPAManager sharedInstance] items] objectAtIndex:indexPath.row];
        }

        if (item) [[CPAManager sharedInstance] removeItem:item];
    }];
    deleteAction.backgroundColor = [UIColor redColor];

    if (indexPath.section == 1) {
        return @[deleteAction, favoriteAction];
    } else {
        return @[deleteAction];
    }
}

@end