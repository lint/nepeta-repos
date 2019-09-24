#import "Tweak.h"

%hook XENHWidgetController

- (void)_loadWebView {
    BOOL isWidgetFullscreen = [[self.widgetMetadata objectForKey:@"isFullscreen"] boolValue];
    BOOL widgetCanScroll = [[self.widgetMetadata objectForKey:@"widgetCanScroll"] boolValue];
    
    CGRect rect = CGRectMake(
                             [[self.widgetMetadata objectForKey:@"x"] floatValue]*SCREEN_WIDTH,
                             [[self.widgetMetadata objectForKey:@"y"] floatValue]*SCREEN_HEIGHT,
                             isWidgetFullscreen ? SCREEN_WIDTH : [[self.widgetMetadata objectForKey:@"width"] floatValue],
                             isWidgetFullscreen ? SCREEN_HEIGHT : [[self.widgetMetadata objectForKey:@"height"] floatValue]
                             );
    
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    
    self.webView = [[EXOWebView alloc] initWithFrame:rect];

    // Setup configuration for the WKWebView
    WKWebViewConfiguration *config = self.webView.configuration;
    //config.processPool = [XENHWidgetController sharedProcessPool];
    
    WKUserContentController *userContentController = self.webView.configuration.userContentController;

    // We also need to inject the settings required by the widget.
    NSMutableString *settingsInjection = [@"" mutableCopy];
    
    NSDictionary *options = [self.widgetMetadata objectForKey:@"options"];
    for (NSString *key in [options allKeys]) {
        if (!key || [key isEqualToString:@""]) {
            continue;
        }
        
        id value = [options objectForKey:key];
        if (!value) {
            value = @"0";
        }
        
        BOOL isNumber = [[value class] isSubclassOfClass:[NSNumber class]];
        
        NSString *valueOut = isNumber ? [NSString stringWithFormat:@"%@", value] : [NSString stringWithFormat:@"\"%@\"", value];
        
        [settingsInjection appendFormat:@"var %@ = %@;", key, valueOut];
    }
    
    WKUserScript *settingsInjector = [[WKUserScript alloc] initWithSource:settingsInjection injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [userContentController addUserScript:settingsInjector];

    config.requiresUserActionForMediaPlayback = YES;
    
    // Configure some private settings on WKWebView
    WKPreferences *preferences = [[WKPreferences alloc] init];
    [preferences _setAllowFileAccessFromFileURLs:YES];
    [preferences _setFullScreenEnabled:YES];
    [preferences _setOfflineApplicationCacheIsEnabled:YES]; // Local storage is needed for Lock+ etc.
    [preferences _setStandalone:YES];
    [preferences _setTelephoneNumberDetectionIsEnabled:NO];
    [preferences _setTiledScrollingIndicatorVisible:NO];
    
    // Developer tools
    // we don't support developer tools yet
    
    config.preferences = preferences;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        [config _setWaitsForPaintAfterViewDidMoveToWindow:NO];
    }
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.scrollView.layer.masksToBounds = NO;
    
    if (!widgetCanScroll) {
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.contentSize = self.webView.bounds.size;
    } else {
        self.webView.scrollView.scrollEnabled = YES;
    }
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollsToTop = NO;
    self.webView.scrollView.minimumZoomScale = 1.0;
    self.webView.scrollView.maximumZoomScale = 1.0;
    self.webView.scrollView.multipleTouchEnabled = YES;

    self.webView.userInteractionEnabled = YES;
    
    self.webView.allowsLinkPreview = NO;
    
    NSURL *url = [NSURL fileURLWithPath:self.widgetIndexFile isDirectory:NO];
    if (url && [[NSFileManager defaultManager] fileExistsAtPath:self.widgetIndexFile]) {
        [self.webView loadFileURL:url allowingReadAccessToURL:[NSURL fileURLWithPath:@"/" isDirectory:YES]];
    }
}

%end