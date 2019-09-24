#import "CPAItem.h"

@implementation CPAItem

+(CPAItem *)itemWithContent:(NSString *)content title:(NSString *)title bundleId:(NSString *)bundleId {
    CPAItem *item = [CPAItem alloc];
    item.content = content;
    item.title = title;
    item.bundleId = bundleId;
    return item;
}

@end