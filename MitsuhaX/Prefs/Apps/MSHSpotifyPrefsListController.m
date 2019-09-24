#import "MSHSpotifyPrefsListController.h"

@implementation MSHSpotifyPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"SpotifyPrefs" target:self] retain];
    }
    return _specifiers;
}
@end