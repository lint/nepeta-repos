#import "Konban.h"

@implementation Konban

+(SBApplication *)app:(NSString *)bundleID {
    return [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
}

+(UIView *)viewFor:(NSString *)bundleID {
    SBApplication *app = [Konban app:bundleID];
    [Konban launch:bundleID];
    [Konban forceBackgrounded:NO forApp:app];
    FBSceneHostManager *manager = [[app mainScene] hostManager];
    [manager enableHostingForRequester:@"Konban" orderFront:YES];
    return [manager hostViewForRequester:@"Konban" enableAndOrderFront:YES];
}

+(void)launch:(NSString *)bundleID {
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:YES];
}

+(void)forceBackgrounded:(BOOL)backgrounded forApp:(SBApplication *)app {
    FBSMutableSceneSettings *sceneSettings = [[[app mainScene] mutableSettings] mutableCopy];
    [sceneSettings setBackgrounded:backgrounded];
    [[app mainScene] updateSettings:sceneSettings withTransitionContext:nil completion:nil];
}


+(void)rehost:(NSString *)bundleID {
    SBApplication *app = [Konban app:bundleID];
    [Konban launch:bundleID];
    [Konban forceBackgrounded:NO forApp:app];
    FBSceneHostManager *manager = [[app mainScene] hostManager];
    [manager enableHostingForRequester:@"Konban" orderFront:YES];
}

+(void)dehost:(NSString *)bundleID {
    SBApplication *app = [Konban app:bundleID];
    [Konban forceBackgrounded:YES forApp:app];
    FBSceneHostManager *manager = [[app mainScene] hostManager];
    [manager disableHostingForRequester:@"Konban"];
}

@end