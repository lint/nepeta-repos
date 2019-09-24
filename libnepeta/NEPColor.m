#import "public/NEPColor.h"

@implementation NEPColor
    +(NEPColor *)fromLong:(unsigned long)color {
        NEPColor *nepColor = [NEPColor alloc];
        nepColor.b = (color) & 0xFF;
        nepColor.g = (color >> 8) & 0xFF;
        nepColor.r = (color >> 16) & 0xFF;
        nepColor.a = (color >> 24) & 0xFF;
        return nepColor;
    }

    -(void)setLong:(unsigned long)color {
        self.b = (color) & 0xFF;
        self.g = (color >> 8) & 0xFF;
        self.r = (color >> 16) & 0xFF;
        self.a = (color >> 24) & 0xFF;
    }

    -(unsigned long)toLong {
        return self.b + (self.g << 8) + (self.r << 16) + (self.a << 24);
    }

    +(NEPColor *)fromUIColor:(UIColor *)color {
        NEPColor *nepColor = [NEPColor alloc];
        CGFloat r, g, b, a;    
        [color getRed: &r green:&g blue:&b alpha:&a];
        nepColor.b = b * 255;
        nepColor.g = g * 255;
        nepColor.r = r * 255;
        nepColor.a = a * 255;
        return nepColor;
    }

    -(bool)isDark {
        return [self lum] < 114.75;
    }

    -(bool)isBlackOrWhite {
        return (self.r > 232 && self.g > 232 && self.b > 232) || (self.r < 23 && self.g < 23 && self.b < 23);
    }

    -(bool)isDistinct:(NEPColor *)color {
        return (abs(self.r-color.r) > 63 || abs(self.g-color.g) > 63 || abs(self.b-color.b) > 63) &&
            !(abs(self.r - self.g) < 7 && abs(self.r-self.b) < 7 && abs(color.r-color.g) < 7 && abs(color.r-color.b) < 7);
    }

    -(double)lum {
        return (0.2126*self.r) + (0.7152*self.g) + (0.0722*self.b) + 12.75;
    }

    -(bool)isContrasting:(NEPColor *)color {
        double luma = [self lum];
        double lumb = [color lum];
        if (luma > lumb) {
            return 1.6 < luma/lumb;
        } else {
            return 1.6 < lumb/luma;
        }
    }

    -(NEPColor *)saturate:(double)saturation {
        CGFloat h, s, b, a;
        [self.uicolor getHue:&h saturation:&s brightness:&b alpha:&a];

        if (s < saturation) {
            UIColor *color = [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
            return [NEPColor fromUIColor:color];
        }
        
        return self;
    }

    -(UIColor *)uicolor {
        return [UIColor colorWithRed:(self.r/255.0) green:(self.g/255.0) blue:(self.b/255.0) alpha:(self.a/255.0)];
    }

    -(UIColor *)uicolorWithAlpha:(double)alpha {
        return [UIColor colorWithRed:(self.r/255.0) green:(self.g/255.0) blue:(self.b/255.0) alpha:alpha];
    }
@end