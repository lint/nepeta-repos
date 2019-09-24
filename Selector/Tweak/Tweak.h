@interface UICalloutBar : UIView

@property (nonatomic,readonly) bool isDisplayingVertically; 
@property (nonatomic, retain) NSArray *extraItems;
@property (nonatomic, retain) UIMenuItem *slcTranslateItem;
@property (nonatomic, retain) UIMenuItem *slcSearchItem;

@end

@interface UICalloutBarButton : UIButton

@property (nonatomic, assign) SEL action;

@end

@interface UIResponder(Selector)

-(void)slcSelectedText:(void (^)(NSString *))callback;
-(void)slcOpenUrl:(NSString *)url withParameter:(NSString *)parameter popup:(bool)popup;

@end