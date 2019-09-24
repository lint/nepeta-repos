#import <Nepeta/NEPColorUtils.h>
#import <MediaPlayer/MPArtworkColorAnalyzer.h>
#import <MediaPlayer/MPArtworkColorAnalysis.h>
#import "NTFManager.h"
#import "IconHeaders.h"

@implementation NTFManager

+(instancetype)sharedInstance {
    static NTFManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NTFManager alloc];
        sharedInstance.iconStore = [NSMutableDictionary new];
        sharedInstance.colorCache = [NSMutableArray new];

        [sharedInstance.colorCache addObject:[NSMutableDictionary new]];
        [sharedInstance.colorCache addObject:[NSMutableDictionary new]];
        [sharedInstance.colorCache addObject:[NSMutableDictionary new]];
    });
    return sharedInstance;
}

-(id)init {
    return [NTFManager sharedInstance];
}

-(UIImage *)getIcon:(NSString *)bundleIdentifier {
    if (self.iconStore[bundleIdentifier]) return self.iconStore[bundleIdentifier];

    SBIconModel *model = [[(SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance] homescreenIconViewMap] iconModel];
    SBIcon *icon = [model applicationIconForBundleIdentifier:bundleIdentifier];
    UIImage *image = [icon getIconImage:2];

    if (!image) {
        icon = [model applicationIconForBundleIdentifier:@"com.apple.Preferences"];
        image = [icon getIconImage:2];
    }

    if (!image) {
        image = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:0 scale:[UIScreen mainScreen].scale];
    }

    if (image) {
        self.iconStore[bundleIdentifier] = [image copy];
    }

    return image ?: [UIImage new];
}

-(void)getDynamicColorForBundleIdentifier:(NSString *)bundleIdentifier withIconImage:(UIImage*)image mode:(NSInteger)mode completion:(void (^)(UIColor *))completionHandler {
    if (!image) return;
    if (self.colorCache[mode][bundleIdentifier]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler([self.colorCache[mode][bundleIdentifier] copy]);
        });
        return;
    }

    if (mode == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIColor *color = [NEPColorUtils averageColor:image withAlpha:1.0];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (!self.colorCache[mode][bundleIdentifier]) {
                    self.colorCache[mode][bundleIdentifier] = [color copy];
                    completionHandler([color copy]);
                } else {
                    completionHandler([self.colorCache[mode][bundleIdentifier] copy]);
                }
            });
        });
    } else if (mode == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NEPPalette *colors = [NEPColorUtils averageColors:image withAlpha:1.0];
            UIColor *color = colors.primary;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                self.colorCache[mode][bundleIdentifier] = [color copy];
                completionHandler([color copy]);
            });
        });
    } else {
        MPArtworkColorAnalyzer *colorAnalyzer = [[MPArtworkColorAnalyzer alloc] initWithImage:image algorithm:0];
        [colorAnalyzer analyzeWithCompletionHandler:^(MPArtworkColorAnalyzer *analyzer, MPArtworkColorAnalysis *analysis) {
            self.colorCache[mode][bundleIdentifier] = [analysis.backgroundColor copy];
        }];
    }
}

@end