#import "CPAObserver.h"
#import "CPAManager.h"

@implementation CPAObserver

-(id)init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteboardUpdated) name:UIPasteboardChangedNotification object:nil];
    return self;
}

-(void)pasteboardUpdated {
    NSString *content = [[UIPasteboard generalPasteboard] string];
    if (!content) return;

    if (self.lastContent && [self.lastContent isEqualToString:content]) return;
    self.lastContent = content;

    NSString *appName = ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]) ?: @"";
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];

    [[CPAManager sharedInstance] addItem:[CPAItem itemWithContent:content title:appName bundleId:bundleIdentifier]];
}

@end