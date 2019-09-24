@interface CBDStepperView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UILabel *valueLabel;

-(NSString *)valueAsString;
-(void)updateValue:(id)sender;

@end