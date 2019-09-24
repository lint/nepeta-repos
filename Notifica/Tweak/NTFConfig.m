#include "NTFConfig.h"

@implementation NTFConfig

-(NTFConfig *)initWithSub:(NSString*)sub prefs:(id)prefs colors:(NSDictionary*)colors {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *prefix = [@"NTF" stringByAppendingString:sub];

    for (NSString *key in [((HBPreferences *)prefs).dictionaryRepresentation allKeys]) {
        if ([key hasPrefix:prefix]) {
            dict[[key stringByReplacingOccurrencesOfString:prefix withString:@""]] = [prefs objectForKey:key];
        }
    }

    for (NSString *key in [colors allKeys]) {
        if ([key hasPrefix:prefix]) {
            dict[[key stringByReplacingOccurrencesOfString:prefix withString:@""]] = [colors objectForKey:key];
        }
    }
    
    if ([sub isEqualToString:@"NowPlaying"]) {
        self.enabled = [([dict objectForKey:@"Enabled"] ?: @(NO)) boolValue];
    } else {
        self.enabled = [([dict objectForKey:@"Enabled"] ?: @(YES)) boolValue];
    }

    self.hideNoOlder = [([dict objectForKey:@"HideNoOlder"] ?: @(YES)) boolValue];
    self.hideAppName = [([dict objectForKey:@"HideAppName"] ?: @(NO)) boolValue];
    self.hideHeaderBackground = [([dict objectForKey:@"HideHeaderBackground"] ?: @(NO)) boolValue];
    self.hideTime = [([dict objectForKey:@"HideTime"] ?: @(NO)) boolValue];
    self.hideX = [([dict objectForKey:@"HideX"] ?: @(NO)) boolValue];
    self.hideIcon = [([dict objectForKey:@"HideIcon"] ?: @(NO)) boolValue];
    self.centerText = [([dict objectForKey:@"CenterText"] ?: @(NO)) boolValue];
    self.colorizeSection = [([dict objectForKey:@"ColorizeSection"] ?: @(NO)) boolValue];
    self.pullToClearAll = [([dict objectForKey:@"PullToClearAll"] ?: @(NO)) boolValue];
    self.alpha = [([dict objectForKey:@"Alpha"] ?: @(1.0)) doubleValue];

    self.style = [([dict objectForKey:@"Style"] ?: @(1)) intValue];
    self.verticalOffset = [([dict objectForKey:@"VerticalOffset"] ?: @(0)) doubleValue];
    self.verticalOffsetNotifications = [([dict objectForKey:@"VerticalOffsetNotifications"] ?: @(0)) doubleValue];
    self.verticalOffsetNowPlaying = [([dict objectForKey:@"VerticalOffsetNowPlaying"] ?: @(0)) doubleValue];
    self.notificationSpacing = [([dict objectForKey:@"NotificationSpacing"] ?: @(8)) doubleValue];
    self.cornerRadius = [([dict objectForKey:@"CornerRadius"] ?: @(13)) intValue];

	self.iconCornerRadius = [([dict objectForKey:@"IconCornerRadius"] ?: @(0)) intValue];

    int backgroundColor = [([dict objectForKey:@"BackgroundColor"] ?: @(1)) intValue];
    int headerTextColor = [([dict objectForKey:@"HeaderTextColor"] ?: @(0)) intValue];
    int contentTextColor = [([dict objectForKey:@"ContentTextColor"] ?: @(0)) intValue];

    int outline = [([dict objectForKey:@"Outline"] ?: @(0)) intValue];
    self.outlineThickness = [([dict objectForKey:@"OutlineThickness"] ?: @(1.0)) doubleValue];

    if (backgroundColor > 0) self.colorizeBackground = true;
    if (headerTextColor > 0) self.colorizeHeader = true;
    if (contentTextColor > 0) self.colorizeContent = true;
    if (outline > 0) self.outline = true;

    if (backgroundColor == 1) self.dynamicBackgroundColor = true;
    if (headerTextColor == 1) self.dynamicHeaderColor = true;
    if (contentTextColor == 1) self.dynamicContentColor = true;
    if (outline == 1) self.dynamicOutlineColor = true;

    self.backgroundColor = LCPParseColorString([dict objectForKey:@"CustomBackgroundColor"], @"#000000:1.0");
    self.backgroundGradientColor = LCPParseColorString([dict objectForKey:@"BackgroundGradientColor"], @"#ffffff:1.0");
    self.headerColor = LCPParseColorString([dict objectForKey:@"CustomHeaderTextColor"], @"#ffffff:1.0");
    self.contentColor = LCPParseColorString([dict objectForKey:@"CustomContentTextColor"], @"#ffffff:1.0");
    self.outlineColor = LCPParseColorString([dict objectForKey:@"CustomOutlineColor"], @"#000000:1.0");

    int _backgroundBlurMode = [([dict objectForKey:@"BackgroundBlurMode"] ?: @(1)) intValue];
    self.backgroundBlurColorAlpha = [([dict objectForKey:@"BackgroundBlurColorAlpha"] ?: @(0.4)) doubleValue];
    self.backgroundBlurAlpha = [([dict objectForKey:@"BackgroundBlurAlpha"] ?: @(1.0)) doubleValue];

    if (_backgroundBlurMode == 1) {
        self.blurColor = [[UIColor whiteColor] colorWithAlphaComponent:self.backgroundBlurColorAlpha];
    } else if (_backgroundBlurMode == 2) {
        self.blurColor = [[UIColor blackColor] colorWithAlphaComponent:self.backgroundBlurColorAlpha];
    }

    self.backgroundGradient = [([dict objectForKey:@"BackgroundGradient"] ?: @(NO)) boolValue];

    self.idleTimerDisabled = [([dict objectForKey:@"IdleTimerDisabled"] ?: @(NO)) boolValue];
    self.experimentalColors = [([dict objectForKey:@"ExperimentalColors"] ?: @(0)) intValue];
    self.hdIcons = [([dict objectForKey:@"HDIcons"] ?: @(NO)) boolValue];
    self.colorizeSection = [([dict objectForKey:@"ColorizeSection"] ?: @(NO)) boolValue];
    self.disableIconShadow = [([dict objectForKey:@"DisableIconShadow"] ?: @(NO)) boolValue];

    return self;
}

@end