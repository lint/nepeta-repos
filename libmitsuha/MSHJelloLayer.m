#import "public/MSHJelloLayer.h"

@implementation MSHJelloLayer

- (id<CAAction>)actionForKey:(NSString *)event {
    if(self.shouldAnimate){
        if ([event isEqualToString:@"path"]) {
            
            CABasicAnimation *animation = [CABasicAnimation
                                           animationWithKeyPath:event];
            animation.duration = 0.15f;
            
            return animation;
        }
    }
    return [super actionForKey:event];
}

@end