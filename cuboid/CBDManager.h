#import "CBDView.h"

@interface CBDManager : NSObject

@property (nonatomic, strong) NSUserDefaults* defaults;
@property (nonatomic, strong) NSMutableDictionary *savedLayouts;

@property (nonatomic, assign) BOOL hideIconLabels;
@property (nonatomic, assign) BOOL hideIconDots;
@property (nonatomic, assign) NSUInteger homescreenColumns;
@property (nonatomic, assign) NSUInteger homescreenRows;
@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat horizontalOffset;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizontalPadding;

@property (nonatomic, assign) CBDView *view;

+(instancetype)sharedInstance;
-(id)init;

-(void)load;
-(void)save;
-(void)reset;
-(void)relayout;
-(void)relayoutAll;
-(void)relayoutAllAnimated;

-(NSDictionary *)currentSettingsAsDictionary;
-(NSString *)layoutDescription:(NSDictionary *)layout;
-(void)loadLayoutWithName:(NSString *)name;
-(void)saveLayoutWithName:(NSString *)name;
-(void)renameLayoutWithName:(NSString *)name toName:(NSString *)newName;
-(void)deleteLayoutWithName:(NSString *)name;
-(void)deleteAllLayouts;

-(void)stopEditing;

-(void)presentViewController:(UIViewController*)viewController animated:(BOOL)animated completion:(id)completion;

@end