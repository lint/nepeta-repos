#import "MSHHomescreenPrefsListController.h"

@implementation MSHHomescreenPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"HomescreenPrefs" target:self] retain];
    }
    return _specifiers;
}
@end