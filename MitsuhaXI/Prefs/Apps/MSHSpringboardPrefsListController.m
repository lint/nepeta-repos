#import "MSHSpringboardPrefsListController.h"

@implementation MSHSpringboardPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"SpringboardPrefs" target:self] retain];
    }
    return _specifiers;
}
@end