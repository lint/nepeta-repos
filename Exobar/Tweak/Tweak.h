#import <Exo/EXOWebView.h>

@interface EXBWebView : EXOWebView

@property (nonatomic, retain) WKUserScript *exbUserScript;

@end

@interface UIStatusBarForegroundStyleAttributes

@property (nonatomic, retain) UIColor *tintColor;

@end

@interface UIStatusBarStyleAttributes : NSObject

-(UIStatusBarForegroundStyleAttributes *)foregroundStyle;

@end

@interface UIStatusBar : UIView

@property (nonatomic, retain) EXBWebView *exbWebView;
@property (nonatomic, retain) UIColor *foregroundColor;

-(id)_currentStyleAttributes;

@end

@interface _UIStatusBarStyleAttributes : NSObject

-(UIColor *)textColor;

@end

@interface _UIStatusBar : UIView

@property (nonatomic,retain) _UIStatusBarStyleAttributes * styleAttributes;
@property (nonatomic, retain) EXBWebView *exbWebView;
@property (nonatomic, retain) UIView *foregroundView;
@property (nonatomic, retain) UIColor *foregroundColor;

@end

@interface UIStatusBarForegroundView : UIView

@end

@interface _UIStatusBarForegroundView : UIView

@end

@interface UISystemNavigationAction : NSObject

@property (nonatomic,readonly) NSArray* destinations;           //@synthesize destinations=_destinations - In the implementation block
-(long long)UIActionType;
-(NSString *)titleForDestination:(unsigned long long)arg1 ;
-(NSString *)URLForDestination:(unsigned long long)arg1 ;
-(id)initWithInfo:(id)arg1 timeout:(double)arg2 forResponseOnQueue:(id)arg3 withHandler:(/*^block*/ id)arg4 ;
-(id)keyDescriptionForSetting:(unsigned long long)arg1 ;
-(id)valueDescriptionForFlag:(long long)arg1 object:(id)arg2 ofSetting:(unsigned long long)arg3 ;
-(bool)sendResponseForDestination:(unsigned long long)arg1 ;
-(id)initWithDestinationContexts:(id)arg1 forResponseOnQueue:(id)arg2 withHandler:(/*^block*/ id)arg3 ;
-(id)_destinationContextForResponseDestination:(unsigned long long)arg1 ;
-(id)destinations;
-(NSString *)bundleIdForDestination:(unsigned long long)arg1 ;

@end


@interface UIApplication(Private)

- (UISystemNavigationAction *)_systemNavigationAction;

@end