#include "EXBTheme.h"

@implementation EXBTheme

+ (EXBTheme *)themeWithDirectoryName:(NSString *)name {
    return [EXBTheme themeWithPath:[EXBThemesDirectory stringByAppendingPathComponent:name]];
}

+ (EXBTheme *)themeWithPath:(NSString*)path {
    return [[EXBTheme alloc] initWithPath:path];
}

- (UIImage *)getImage:(NSString *)filename {
    return [UIImage imageWithContentsOfFile:[self getPath:filename]];
}

- (UIImage *)getPreviewImage:(BOOL)modern {
    if (_previewImage) return _previewImage;

    if (modern) {
        _previewImage = [self getImage:@"preview_modern.png"];

        if (!_previewImage) {
            _previewImage = [self getImage:@"preview_modern.jpg"];
        }
    }

    if (!_previewImage) {
        _previewImage = [self getImage:@"preview.png"];
    }

    if (!_previewImage) {
        _previewImage = [self getImage:@"preview.jpg"];
    }

    return _previewImage;
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
        self.info = [[NSDictionary alloc] initWithContentsOfFile:[self getPath:@"info.plist"]];
    }
    return self;
}

@end