#import <Cephei/HBPreferences.h>
#import <libcolorpicker.h>

@interface NTFConfig : NSObject

@property (nonatomic,assign) bool enabled;

@property (nonatomic,retain) UIColor *backgroundColor;
@property (nonatomic,retain) UIColor *backgroundGradientColor;
@property (nonatomic,retain) UIColor *blurColor;
@property (nonatomic,retain) UIColor *contentColor;
@property (nonatomic,retain) UIColor *headerColor;
@property (nonatomic,retain) UIColor *outlineColor;

@property (nonatomic,assign) bool dynamicHeaderColor;
@property (nonatomic,assign) bool dynamicBackgroundColor;
@property (nonatomic,assign) bool dynamicContentColor;
@property (nonatomic,assign) bool dynamicOutlineColor;

@property (nonatomic,assign) bool colorizeHeader;
@property (nonatomic,assign) bool colorizeBackground;
@property (nonatomic,assign) bool colorizeContent;
@property (nonatomic,assign) bool colorizeSection;

@property (nonatomic,assign) bool backgroundGradient;

@property (nonatomic,assign) bool hideIcon;
@property (nonatomic,assign) bool hideAppName;
@property (nonatomic,assign) bool hideHeaderBackground;
@property (nonatomic,assign) bool hideTime;
@property (nonatomic,assign) bool hideX;
@property (nonatomic,assign) bool outline;

@property (nonatomic,assign) bool hideNoOlder;
@property (nonatomic,assign) bool centerText;
@property (nonatomic,assign) bool pullToClearAll;

@property (nonatomic,assign) double verticalOffset;
@property (nonatomic,assign) double verticalOffsetNotifications;
@property (nonatomic,assign) double verticalOffsetNowPlaying;
@property (nonatomic,assign) double notificationSpacing;
@property (nonatomic,assign) double outlineThickness;
@property (nonatomic,assign) int style;
@property (nonatomic,assign) double alpha;
@property (nonatomic,assign) double backgroundBlurAlpha;
@property (nonatomic,assign) double backgroundBlurColorAlpha;
@property (nonatomic,assign) int cornerRadius;
@property (nonatomic,assign) int iconCornerRadius;

@property (nonatomic,assign) bool idleTimerDisabled;
@property (nonatomic,assign) NSInteger experimentalColors;
@property (nonatomic,assign) bool hdIcons;
@property (nonatomic,assign) bool disableIconShadow;

-(NTFConfig *)initWithSub:(NSString*)sub prefs:(id)prefs colors:(NSDictionary*)colors;

@end