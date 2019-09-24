@interface NTFManager : NSObject

@property (nonatomic, retain) NSMutableArray *colorCache;
@property (nonatomic, retain) NSMutableDictionary *iconStore;
@property (nonatomic, retain) UIColor *lastArtworkColor;

+(instancetype)sharedInstance;
-(id)init;
-(UIImage *)getIcon:(NSString *)bundleIdentifier;
-(void)getDynamicColorForBundleIdentifier:(NSString *)bundleIdentifier withIconImage:(UIImage*)image mode:(NSInteger)mode completion:(void (^)(UIColor *))completionHandler;

@end