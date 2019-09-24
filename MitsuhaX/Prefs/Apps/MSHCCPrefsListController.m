#import "MSHCCPrefsListController.h"

@implementation MSHCCPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"CCPrefs" target:self] retain];
    }
    return _specifiers;
}
@end