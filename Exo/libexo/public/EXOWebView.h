#import <WebKit/WebKit.h>

@interface EXOWebView : WKWebView <WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *exoWebView;
@property (nonatomic, retain) WKWebViewConfiguration *exoWebViewConfig;
@property (nonatomic, retain) WKUserScript *exoUserScript;
@property (nonatomic, retain) WKUserContentController *exoContentController;
@property (nonatomic, retain) NSMutableDictionary *exoInternalVariables;

-(id)initWithFrame:(CGRect)frame;
-(void)exoUpdate:(NSDictionary *)dictionary;
-(void)exoInternalUpdate:(NSDictionary *)dictionary;
-(void)exoAction:(NSString *)action withArguments:(NSDictionary *)arguments;

@end