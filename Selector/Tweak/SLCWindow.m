#import "SLCWindow.h"

UIWindow* SLCGetMainWindow() {
    return [[[UIApplication sharedApplication] windows] firstObject];
}

@implementation SLCWindow

@synthesize webViewConfig, webView, isOpen, blurView, closeLabel, activityIndicatorView, topPadding;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.windowLevel = UIWindowLevelAlert + 1;

    [self setUserInteractionEnabled:YES];
    self.hidden = YES;
    self.alpha = 0.0;

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.bounds;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.blurView];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];

    self.topPadding = 0;
    CGFloat sidePadding = 20;

    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        self.topPadding = window.safeAreaInsets.top;
    }

    self.topPadding += 20;

    self.webViewConfig = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(sidePadding, self.frame.size.height, self.frame.size.width - sidePadding * 2, self.frame.size.height * 0.8 - self.topPadding) configuration:self.webViewConfig];
    self.webView.navigationDelegate = self;
    self.webView.layer.cornerRadius = 13;
    self.webView.layer.masksToBounds = true;
    [self addSubview:self.webView];

    self.closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height * 0.8,self.frame.size.width,self.frame.size.height * 0.2)];
    self.closeLabel.textAlignment = NSTextAlignmentCenter;
    self.closeLabel.textColor = [UIColor whiteColor];
    self.closeLabel.text = @"Tap here to close";
    [self.closeLabel setFont:[UIFont systemFontOfSize:24]];
    [self addSubview: self.closeLabel];

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.frame = self.webView.frame;
    self.activityIndicatorView.hidesWhenStopped = true;
    [self.activityIndicatorView setUserInteractionEnabled:NO];
    [self.webView addSubview: self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];

    return self;
}

-(void)handleTap {
    [self setVisibility:false];
}

-(void)setVisibility:(bool)state {
    self.isOpen = state;
    if (state) {
        [self setHidden: NO];

        CGRect webViewFrame = self.webView.frame;
        if (self.alpha != 1.0) {
            self.alpha = 0.0;
            webViewFrame.origin.y = self.frame.size.height;
            self.webView.frame = webViewFrame;
        }

        webViewFrame.origin.y = self.topPadding;

        [UIView animateWithDuration:(0.2) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
            self.webView.frame = webViewFrame;
        } completion:NULL];

        [SLCGetMainWindow() endEditing:YES];
    } else {
        self.alpha = 1.0;

        CGRect webViewFrame = self.webView.frame;
        webViewFrame.origin.y = self.frame.size.height;

        [UIView animateWithDuration:(0.3) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0;
            self.webView.frame = webViewFrame;
        } completion:NULL];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.3) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self setHidden: YES];
        });
    }
}

-(void)animateActivity {
    [self.activityIndicatorView startAnimating];
}

-(void)open:(NSString*)url {
    if (!self.isOpen) [self setVisibility:true];
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:request];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView stopAnimating];
}

@end