@interface CBDContentView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIButton *backButton;

-(void)refresh;

@end