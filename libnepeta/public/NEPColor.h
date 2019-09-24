#import <UIKit/UIKit.h>

@interface NEPColor : NSObject
@property (nonatomic) UInt8 r;
@property (nonatomic) UInt8 g;
@property (nonatomic) UInt8 b;
@property (nonatomic) UInt8 a;

+(NEPColor *)fromUIColor:(UIColor *)color;
+(NEPColor *)fromLong:(unsigned long)color;
-(unsigned long)toLong;
-(void)setLong:(unsigned long)color;
-(bool)isDark;
-(bool)isBlackOrWhite;
-(bool)isDistinct:(NEPColor *)color;
-(bool)isContrasting:(NEPColor *)color;
-(NEPColor *)saturate:(double)saturation;
-(UIColor *)uicolorWithAlpha:(double)alpha;
-(double)lum;
-(UIColor *)uicolor;

@end