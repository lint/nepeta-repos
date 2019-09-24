@interface CPAItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *bundleId;
@property (nonatomic, retain) NSString *content;

+(CPAItem *)itemWithContent:(NSString *)content title:(NSString *)title bundleId:(NSString *)bundleId;

@end