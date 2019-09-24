#define SXIPrefsIdentifier @"io.ominousness.stackxi"
#define SXINotification @"io.ominousness.stackxi/ReloadPrefs"
#define SXIThemesDirectory @"/Library/StackXI/"

@interface SXITheme : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, retain) UIImage *image;
+ (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second;
+ (SXITheme *)themeWithPath:(NSString *)path;
- (NSString *)getPath:(NSString *)filename;
- (UIImage *)getIcon:(NSString *)filename;
- (UIImage *)getImage:(NSString *)filename;
- (id)initWithPath:(NSString *)path;
- (void)preparePreviewImage;

@end