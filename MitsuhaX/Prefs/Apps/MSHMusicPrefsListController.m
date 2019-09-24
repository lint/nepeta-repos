#import "MSHMusicPrefsListController.h"

@implementation MSHMusicPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"MusicPrefs" target:self] retain];
    }
    return _specifiers;
}
@end