#import <ControlCenterUIKit/CCUIContentModuleContentViewController-Protocol.h>

@class CCUIButtonModuleView, UIImage, UIColor, CCUICAPackageDescription, NSString;

@interface CCUIButtonModuleViewController : UIViewController <CCUIContentModuleContentViewController> {

	CCUIButtonModuleView* _buttonModuleView;
	BOOL _expanded;

}

@property (nonatomic,retain) UIImage * glyphImage; 
@property (nonatomic,retain) UIColor * glyphColor; 
@property (nonatomic,retain) UIImage * selectedGlyphImage; 
@property (nonatomic,retain) UIColor * selectedGlyphColor; 
@property (nonatomic,retain) CCUICAPackageDescription * glyphPackageDescription; 
@property (nonatomic,copy) NSString * glyphState; 
@property (assign,getter=isSelected,nonatomic) BOOL selected; 
@property (getter=isExpanded,nonatomic,readonly) BOOL expanded;                               //@synthesize expanded=_expanded - In the implementation block
@property (nonatomic,readonly) CCUIButtonModuleView * buttonView; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
@property (nonatomic,readonly) double preferredExpandedContentHeight; 
@property (nonatomic,readonly) double preferredExpandedContentWidth; 
@property (nonatomic,readonly) BOOL providesOwnPlatter; 
-(UIImage *)glyphImage;
-(void)setGlyphImage:(UIImage *)arg1 ;
-(void)setSelectedGlyphImage:(UIImage *)arg1 ;
-(UIImage *)selectedGlyphImage;
-(void)setGlyphColor:(UIColor *)arg1 ;
-(CCUIButtonModuleView *)buttonView;
-(UIColor *)glyphColor;
-(void)setGlyphPackageDescription:(CCUICAPackageDescription *)arg1 ;
-(void)setGlyphState:(NSString *)arg1 ;
-(CCUICAPackageDescription *)glyphPackageDescription;
-(NSString *)glyphState;
-(void)setSelectedGlyphColor:(UIColor *)arg1 ;
-(UIColor *)selectedGlyphColor;
-(void)buttonTapped:(id)arg1 forEvent:(id)arg2 ;
-(void)_buttonTapped:(id)arg1 forEvent:(id)arg2 ;
-(double)preferredExpandedContentHeight;
-(void)willTransitionToExpandedContentMode:(BOOL)arg1 ;
-(void)didTransitionToExpandedContentMode:(BOOL)arg1 ;
-(void)viewDidLoad;
-(BOOL)isSelected;
-(void)setSelected:(BOOL)arg1 ;
-(BOOL)isExpanded;
@end
