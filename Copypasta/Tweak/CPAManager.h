#import "CPAItem.h"

@interface CPAManager : NSObject {
  NSMutableArray *_items;
  NSMutableArray *_favoriteItems;
}

@property (nonatomic, assign) NSInteger numberOfItems;

+(instancetype)sharedInstance;
-(id)init;
-(void)reload;
-(NSMutableArray*)items;
-(NSMutableArray*)favoriteItems;
-(void)addItem:(CPAItem *)item;
-(void)removeItem:(CPAItem *)item;
-(void)favoriteItem:(CPAItem *)item;
-(void)save;

@end