@interface CPAObserver : NSObject

@property (nonatomic, retain) NSString *lastContent;

-(id)init;
-(void)pasteboardUpdated;

@end