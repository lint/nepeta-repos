#import <UIKit/UIKit.h>
#import "NEPPalette.h"

@interface NEPColorUtils : NSObject

+(BOOL)isDark:(UIColor *)color;
+(NEPPalette *)averageColors:(UIImage *)img withAlpha:(double)alpha;
+(UIColor *)averageColor:(UIImage *)image withAlpha:(double)alpha;
+(UIColor *)averageColorNew:(UIImage *)img withAlpha:(double)alpha;
+(UIColor *)colorWithMinimumSaturation:(UIColor *)img withSaturation:(double)saturation;

@end