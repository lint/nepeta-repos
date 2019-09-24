#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>

@interface _UIBackdropViewSettings : NSObject

@property (nonatomic, retain) UIColor * colorTint;
@property (nonatomic, assign) double blurRadius;

+(instancetype)settingsForStyle:(NSInteger)style;

@end

@interface _UIBackdropView : UIView

@property (nonatomic, assign) NSInteger style;   

-(instancetype)initWithStyle:(NSInteger)style;
-(void)transitionToStyle:(NSInteger)style;
-(void)transitionToSettings:(_UIBackdropViewSettings *)settings;
-(void)transitionIncrementallyToStyle:(NSInteger)style weighting:(double)weight;
-(void)transitionIncrementallyToSettings:(_UIBackdropViewSettings *)settings weighting:(double)weight;
-(void)setBlurRadius:(double)radius;
-(void)_setContinuousCornerRadius:(double)radius;

@end

@interface CALayer (Private)

@property (nonatomic, assign) BOOL continuousCorners;

@end

@interface FLHGradientLayer : CAGradientLayer

@end

@interface SBHUDView : UIView

@property (assign,nonatomic) float progress;
@property (nonatomic, retain) FLHGradientLayer *flhLayer;
@property (nonatomic, retain) FLHGradientLayer *flhBackgroundLayer;
@property (nonatomic, retain) FLHGradientLayer *flhKnobLayer;
@property (nonatomic, retain) _UIBackdropView *flhBackdropBlur;
@property (nonatomic, assign) CGRect flhFullFrame;

-(void)setProgress:(float)arg1 ;
-(float)flhRealProgress;

@end

@interface SBVolumeHUDView : SBHUDView

@property(assign, nonatomic) int mode;

@end

@interface SBRingerHUDView : SBHUDView

-(BOOL)isSilent;

@end

@interface SBHUDWindow : UIWindow

@end

@interface SBHUDController : NSObject

+(id)sharedHUDController;
-(void)_orderWindowOut:(id)arg1 ;
-(id)visibleHUDView;
-(void)hideHUDView;
-(id)visibleOrFadingHUDView;
-(void)_recenterHUDView;
-(void)_createUI;
-(void)presentHUDView:(id)arg1 ;
-(void)dealloc;
-(void)_tearDown;
-(void)reorientHUDIfNeeded:(BOOL)arg1 ;
-(void)presentHUDView:(id)arg1 autoDismissWithDelay:(double)arg2 ;

@end

@interface VolumeControl : NSObject

+(id)sharedVolumeControl;
-(void)setMediaVolume:(float)arg1 ;

@end