#import "MSHSoundcloudPrefsListController.h"

@implementation MSHSoundcloudPrefsListController
- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"SoundcloudPrefs" target:self] retain];
    }
    return _specifiers;
}
@end