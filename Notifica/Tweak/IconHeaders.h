@interface SBIcon : NSObject

-(UIImage *)getIconImage:(int)arg1 ;

@end

@interface SBIconModel : NSObject

-(SBIcon *)applicationIconForBundleIdentifier:(id)arg1 ;

@end

@interface SBIconViewMap : NSObject

@property (nonatomic,readonly) SBIconModel * iconModel;

@end

@interface SBIconController : UIViewController

+(id)sharedInstance;
-(SBIconViewMap *)homescreenIconViewMap;

@end

@interface UIImage (Private)

+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;

@end