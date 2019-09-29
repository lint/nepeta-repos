#import "MSHDeezerPrefsListController.h"

@implementation MSHDeezerPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"DeezerPrefs" target:self] retain];
    }
    return _specifiers;
}
@end