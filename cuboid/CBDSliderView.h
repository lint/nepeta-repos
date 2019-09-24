@interface CBDSliderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *valueButton;
@property (nonatomic, assign) BOOL isInteger;

-(NSString *)valueAsString;
-(void)updateValue:(id)sender;

@end