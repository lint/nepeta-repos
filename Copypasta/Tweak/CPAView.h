@interface CPAView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UIImage* placeholderImage;
@property (nonatomic, retain) UIButton* dismissButton;
@property (nonatomic, retain) UIVisualEffectView* blurView;
@property (nonatomic, retain) UIView* emptyView;
@property (nonatomic, retain) UILabel* listEmptyLabel;
@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, assign) CGFloat lastHeight;
@property (nonatomic, assign) CGRect baseFrame;
@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, assign) bool isOpen;
@property (nonatomic, assign) bool isOpenFully;
@property (nonatomic, assign) bool showNames;
@property (nonatomic, assign) bool showIcons;
@property (nonatomic, assign) bool darkMode;
@property (nonatomic, assign) bool useBlur;
@property (nonatomic, assign) bool dismissAfterPaste;
@property (nonatomic, assign) bool dismissesFully;
@property (nonatomic, assign) bool wantsAnimations;
@property (nonatomic, assign) bool playsHapticFeedback;
@property (nonatomic, retain) UIView* wrapperView;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, retain) NSMutableDictionary* icons;

-(void)refresh;
-(void)toggle;
-(void)show:(BOOL)fully animated:(BOOL)animated;
-(void)hide:(BOOL)fully animated:(BOOL)animated;
-(void)cpaPaste:(NSString*)text;
-(void)recreateBlur;
-(void)setHeight:(CGFloat)height;
-(void)preloadIcons;

@end