#include "SXICommon.h"

@implementation SXITheme

@synthesize name, image;

+ (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second
{
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    CGSize mergedSize = CGSizeMake(firstWidth + secondWidth + 5, MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    
    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [second drawInRect:CGRectMake(firstWidth + 5, 0, secondWidth, secondHeight)]; 
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (SXITheme*)themeWithPath:(NSString*)path {
    return [[SXITheme alloc] initWithPath:path];
}

- (UIImage *)getIcon:(NSString *)filename {
    return [[self getImage:filename] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)getImage:(NSString *)filename {
    return [UIImage imageWithContentsOfFile:[self getPath:filename]];
}

- (NSString *)getPath:(NSString *)filename {
    return [self.path stringByAppendingPathComponent:filename];
}

- (id)initWithPath:(NSString*)path {
    BOOL isDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if (!exists || !isDir) {
        return nil;
    }
    
    if ((self = [super init])) {
        self.path = path;
        self.name = [[path lastPathComponent] stringByDeletingPathExtension];
    }
    return self;
}

- (void)preparePreviewImage {
    UIImage *previewImage = [self getImage:@"SXIPreview.png"];

    if (previewImage) {
        self.image = previewImage;
        return;
    }

    UIImage *clearAll = [self getImage:@"SXIClearAll.png"];
    UIImage *collapse = [self getImage:@"SXICollapse.png"];

    self.image = [SXITheme mergeImage:collapse withImage:clearAll];
}

@end