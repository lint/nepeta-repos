/* Obj-C port of: https://github.com/jathu/UIImageColors/blob/master/Sources/UIImageColors.swift
MIT Licensed, original author: @jathu
*/

#import "public/NEPColor.h"
#import "public/NEPPalette.h"
#import "public/NEPColorUtils.h"

@implementation NEPColorUtils

+(BOOL)isDark:(UIColor *)color {
    size_t count = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);

    CGFloat darknessScore = 0;
    if (count == 2) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
    } else if (count == 4) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
    }

    if (darknessScore >= 125) {
        return NO;
    }

    return YES;
}

+(NEPPalette *)averageColors:(UIImage *)img withAlpha:(double)alpha {
    CGSize newSize = img.size;
    double resizeTo = 25;
    double ratio = img.size.height/img.size.width;
    if (img.size.width < img.size.height) {
        newSize = CGSizeMake(resizeTo/ratio, resizeTo);
    } else {
        newSize = CGSizeMake(resizeTo, resizeTo*ratio);
    }

    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
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
        //if (data[i+3] >= 127) {
            unsigned long rgba = data[i] + (data[i+1] << 8) + (data[i+2] << 16) + (data[i+3] << 24);
            [colors addObject:@(rgba)];
        //}
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

    NEPColor *proposed[4] = {nil, nil, nil, nil};
    NSDictionary *edgeColor;
    if (dictArray.count > 0) {
        edgeColor = (NSDictionary *)dictArray[0];
    } else {
        edgeColor = @{
            @"color": @(0),
            @"count": @(1)
        };
    }
    
    NEPColor *tempColor = [NEPColor fromLong:(unsigned long)[edgeColor[@"color"] longValue]];
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

    proposed[0] = [NEPColor fromLong:(unsigned long)[edgeColor[@"color"] longValue]];
    [dictArray removeAllObjects];

    bool needDark = ![proposed[0] isDark];

    [colors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [tempColor setLong:(unsigned long)[(NSNumber*)obj longValue]];
        [tempColor saturate:0.15];
        if ([tempColor isDark] == needDark) {
            NSNumber *count = @([colors countForObject:obj]);
            [dictArray addObject:@{
                @"color": @([tempColor toLong]),
                @"count": count
            }];
        }
    }];

    [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];

    for (NSDictionary *cc in dictArray) {
        [tempColor setLong:(unsigned long)[cc[@"color"] longValue]];

        if (!proposed[1]) {
            if ([tempColor isContrasting:proposed[0]]) {
                proposed[1] = tempColor;
            }
        } else if (!proposed[2]) {
            if ([tempColor isContrasting:proposed[0]] && [proposed[1] isDistinct:tempColor]) {
                proposed[2] = tempColor;
            }
        } else if (!proposed[3]) {
            if (![tempColor isContrasting:proposed[0]] && [proposed[1] isDistinct:tempColor] && [proposed[2] isDistinct:tempColor]) {
                proposed[3] = tempColor;
                break;
            }
        }
    }

    bool isDarkBackground = [proposed[0] isDark];

    for (int i = 0; i < 4; i++) {
        if (!proposed[i]) {
            proposed[i] = isDarkBackground ? [NEPColor fromLong:0xFFFFFFFF] : [NEPColor fromLong:0];
        }
    }

    NEPPalette *palette = [NEPPalette alloc];

    palette.background = [proposed[0] uicolorWithAlpha:alpha];
    palette.primary = [proposed[1] uicolorWithAlpha:alpha];
    palette.secondary = [proposed[2] uicolorWithAlpha:alpha];
    palette.detail = [proposed[3] uicolorWithAlpha:alpha];
    
    return palette;
}

+(UIColor *)averageColorNew:(UIImage *)img withAlpha:(double)alpha {
    return [NEPColorUtils averageColors:img withAlpha:alpha].background;
}

+(UIColor *)averageColor:(UIImage *)image withAlpha:(double)alpha {
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
        averageColor = [NEPColorUtils colorWithMinimumSaturation:averageColor withSaturation:0.15];
        
        //Return average color
        return averageColor;
    } else {
        //Get average
        UIColor *averageColor = [UIColor colorWithRed:((CGFloat)rgba[0])/255.0 green:((CGFloat)rgba[1])/255.0 blue:((CGFloat)rgba[2])/255.0 alpha:alpha];
        
        //Improve color
        averageColor = [NEPColorUtils colorWithMinimumSaturation:averageColor withSaturation:0.15];
        
        //Return average color
        return averageColor;
    }
}

+(UIColor *)colorWithMinimumSaturation:(UIColor *)img withSaturation:(double)saturation {
    if (!img)
        return nil;
    
    CGFloat h, s, b, a;
    [img getHue:&h saturation:&s brightness:&b alpha:&a];
    
    if (s < saturation)
        return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:a];
    
    return img;
}

@end