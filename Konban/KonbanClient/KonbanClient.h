@interface UIStatusBar_Base : UIView

@property (assign,nonatomic) BOOL hidden;                    
-(BOOL)isHidden;
-(void)setHidden:(BOOL)arg1 ;
-(void)setHidden:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)setHidden:(BOOL)arg1 animationParameters:(id)arg2 ;
-(BOOL)hidden;

@end

@interface _UIStatusBar : UIView

@end

@interface UIStatusBar : UIStatusBar_Base

@end