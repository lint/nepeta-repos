UIColor * colorWithMinimumSaturation(UIColor *self, double saturation){
    if (!self)
        return nil;
    
    CGFloat h, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    if (s < saturation)
        return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
    
    return self;
}

/* Obj-C port of: https://github.com/jathu/UIImageColors/blob/master/Sources/UIImageColors.swift
MIT Licensed, original author: @jathu
*/

@interface MSHColor : NSObject
@property (nonatomic) UInt8 r;
@property (nonatomic) UInt8 g;
@property (nonatomic) UInt8 b;
@property (nonatomic) UInt8 a;


+(MSHColor *)fromLong:(unsigned long)color;
-(void)setLong:(unsigned long)color;
-(bool)isBlackOrWhite;

@end

@implementation MSHColor
    +(MSHColor *)fromLong:(unsigned long)color {
        MSHColor *mshColor = [MSHColor alloc];
        mshColor.b = (color) & 0xFF;
        mshColor.g = (color >> 8) & 0xFF;
        mshColor.r = (color >> 16) & 0xFF;
        mshColor.a = (color >> 24) & 0xFF;
        return mshColor;
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

    -(bool)isBlackOrWhite {
        return (self.r > 232 && self.g > 232 && self.b > 232) || (self.r < 23 && self.g < 23 && self.b < 23);
    }

    -(UIColor *)uicolorWithAlpha:(double)alpha {
        return [UIColor colorWithRed:(self.r/255.0) green:(self.g/255.0) blue:(self.b/255.0) alpha:alpha];
    }
@end

UIColor * averageColorNew(UIImage *self, double alpha) {
    CGSize newSize = self.size;
    double resizeTo = 25;
    double ratio = self.size.height/self.size.width;
    if (self.size.width < self.size.height) {
        newSize = CGSizeMake(resizeTo/ratio, resizeTo);
    } else {
        newSize = CGSizeMake(resizeTo, resizeTo*ratio);
    }

    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();

    CGImageRef image = [newImage CGImage];
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    unsigned long length = sizeof(UInt8) * width * height * 4;

    UInt8 *data = (UInt8 *) malloc(length);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetBlendMode(cgContext, kCGBlendModeCopy);
    CGContextDrawImage(cgContext, CGRectMake(0.0f, 0.0f, width, height), image);

    CGContextRelease(cgContext);
    CGColorSpaceRelease(colorSpace);

    NSCountedSet *colors = [[NSCountedSet alloc] initWithCapacity:width*height];
    for (unsigned long i = 0; i < length; i+=4) {
        if (data[i+3] >= 127) {
            unsigned long rgba = data[i] + (data[i+1] << 8) + (data[i+2] << 16) + (data[i+3] << 24);
            [colors addObject:@(rgba)];
        }
    }

    free(data);

    int threshold = round(((CGFloat)width)/100);

    NSMutableArray *dictArray = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSNumber *count = @([colors countForObject:obj]);
        if ([count intValue] > threshold) {
            [dictArray addObject:@{
                @"color": obj,
                @"count": count
            }];
        }
    }];
    
    [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];

    NSDictionary *edgeColor;
    if (dictArray.count > 0) {
        edgeColor = (NSDictionary *)dictArray[0];
    } else {
        edgeColor = @{
            @"color": @(0),
            @"count": @(1)
        };
    }
    
    MSHColor *tempColor = [MSHColor fromLong:(unsigned long)[edgeColor[@"color"] longValue]];
    if ([tempColor isBlackOrWhite] && dictArray.count > 0) {
        for (NSDictionary *cc in dictArray) {
            if ([cc[@"count"] doubleValue] / [edgeColor[@"count"] doubleValue] > 0.3) {
                [tempColor setLong:(unsigned long)[cc[@"color"] longValue]];
                if (![tempColor isBlackOrWhite]) {
                    edgeColor = cc;
                    break;
                }
            } else {
                break;
            }
        }
    }

    return [tempColor uicolorWithAlpha:alpha];
}

UIColor * averageColor(UIImage *image, double alpha){
    //Work within the RGB colorspoace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Draw our image down to 1x1 pixels
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    //Check if image alpha is 0
    if (rgba[3] == 0) {
        CGFloat imageAlpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = imageAlpha/255.0;
        UIColor *averageColor = [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier green:((CGFloat)rgba[1])*multiplier blue:((CGFloat)rgba[2])*multiplier alpha:imageAlpha];
        
        //Improve color
        averageColor = colorWithMinimumSaturation(averageColor, 0.15);
        
        //Return average color
        return averageColor;
    } else {
        //Get average
        UIColor *averageColor = [UIColor colorWithRed:((CGFloat)rgba[0])/255.0 green:((CGFloat)rgba[1])/255.0 blue:((CGFloat)rgba[2])/255.0 alpha:alpha];
        
        //Improve color
        averageColor = colorWithMinimumSaturation(averageColor, 0.15);
        
        //Return average color
        return averageColor;
    }
}