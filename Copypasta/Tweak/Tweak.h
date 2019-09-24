@interface UIKBTree : NSObject

@property (assign,nonatomic) int type; 
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSMutableDictionary * properties; 

@end

@interface UIInputSetHostView : UIView

@property (nonatomic, assign) CGRect cpaFrame;
@property (nonatomic, assign) BOOL cpaHasFrame;
-(BOOL)_lightStyleRenderConfig;
-(id)_rootInputWindowController;

@end

@interface UIInputViewSetPlacement_GenericApplicator : NSObject

-(void)cpaConstraint:(BOOL)show;

@end

@interface UIInputViewSetPlacement : NSObject

- (bool)accessoryViewWillAppear;
- (double)alpha;
- (Class)applicatorClassForKeyboard:(bool)arg1;
- (id)applicatorInfoForOwner:(id)arg1;
- (void)checkSizeForOwner:(id)arg1;
- (id)delegate;
- (void)encodeWithCoder:(id)arg1;
- (double)extendedHeight;
- (id)horizontalConstraintForInputViewSet:(id)arg1 hostView:(id)arg2 containerView:(id)arg3;
- (id)initWithCoder:(id)arg1;
- (bool)inputViewWillAppear;
- (bool)isEqual:(id)arg1;
- (bool)isInteractive;
- (bool)isUndocked;
- (unsigned long long)notificationsForTransitionToPlacement:(id)arg1;
- (void)setDelegate:(id)arg1;
- (void)setDirty;
- (void)setExtendedHeight:(double)arg1;
- (bool)showsInputViews;
- (bool)showsKeyboard;
- (id)verticalConstraintForInputViewSet:(id)arg1 hostView:(id)arg2 containerView:(id)arg3;
- (id)widthConstraintForInputViewSet:(id)arg1 hostView:(id)arg2 containerView:(id)arg3;
- (CGRect)remoteIntrinsicContentSizeForInputViewInSet:(id)arg1 includingIAV:(BOOL)arg2;

@end

@interface UIInputWindowController : UIViewController

@property (nonatomic,retain) UIInputViewSetPlacement_GenericApplicator *applicator;
@property (nonatomic,retain) NSLayoutConstraint * inputViewHeightConstraint;
@property (nonatomic,readonly) UIInputSetHostView * hostView; 
@property (nonatomic,retain) UIInputViewSetPlacement * placement;  
@property (retain,readonly) UIView * containerView; 
-(void)updateInputAssistantView:(id)arg1 ;
-(void)candidateBarWillChangeHeight:(double)arg1 withDuration:(double)arg2 ;
-(UIView *)_inputView;
-(UIView *)_inputAccessoryView;
-(UIView *)_inputAssistantView;
-(void)cpaRepositionEverything;
-(void)resetVerticalConstraint;

@end

@interface UIKeyboardImpl : UIView

+(id)activeInstance;
-(void)insertText:(NSString *)text;

@end