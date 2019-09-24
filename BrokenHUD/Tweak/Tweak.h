#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>


@interface SBMediaController : NSObject 

- (void)_commitVolumeChange:(id)arg1;
- (void)decreaseVolume;
- (void)increaseVolume;
- (void)_changeVolumeBy:(float)arg1;
- (void)setVolume:(float)arg1;

@end

@interface SBHUDView : UIView {

	int _level;
	NSString* _title;
	NSString* _subtitle;
	UIImage* _image;
	BOOL _showsProgress;
	float _progress;
	UIView* _blockView;
	UIView* _backdropView;
	UIImageView* _backdropMaskImageView;

}

@property (assign,nonatomic) int level;                        //@synthesize level=_level - In the implementation block
@property (nonatomic,retain) NSString * title; 
@property (nonatomic,retain) NSString * subtitle; 
@property (nonatomic,retain) UIImage * image; 
@property (assign,nonatomic) BOOL showsProgress;               //@synthesize showsProgress=_showsProgress - In the implementation block
@property (assign,nonatomic) float progress;                   //@synthesize progress=_progress - In the implementation block
+(float)progressIndicatorStep;
+(long long)numberOfProgressIndicatorSteps;
-(id)initWithHUDViewLevel:(int)arg1 ;
-(id)_blockColorForValue:(float)arg1 ;
-(void)_updateBlockView:(id)arg1 value:(float)arg2 blockSize:(CGSize)arg3 point:(CGPoint)arg4 ;
-(BOOL)displaysLabel;
-(void)_updateBackdropMask;
-(void)_updateBlockView;
-(void)cancelDismissal;
-(void)layoutSubviews;
-(void)setImage:(UIImage *)arg1 ;
-(void)setTitle:(NSString *)arg1 ;
-(NSString *)title;
-(UIImage *)image;
-(void)setLevel:(int)arg1 ;
-(int)level;
-(void)setProgress:(float)arg1 ;
-(void)setSubtitle:(NSString *)arg1 ;
-(NSString *)subtitle;
-(float)progress;
-(void)dismissWithCompletion:(/*^block*/id)arg1 ;
-(void)setShowsProgress:(BOOL)arg1 ;
-(BOOL)showsProgress;
@end

@interface SBVolumeHUDView : SBHUDView {

	int _mode;
	BOOL _headphonesPresent;
	float _euVolumeLimit;

}

@property (assign,nonatomic) int mode;                            //@synthesize mode=_mode - In the implementation block
@property (assign,nonatomic) BOOL headphonesPresent;              //@synthesize headphonesPresent=_headphonesPresent - In the implementation block
@property (assign,nonatomic) float EUVolumeLimit;                 //@synthesize euVolumeLimit=_euVolumeLimit - In the implementation block
@property (assign,nonatomic) int extras;
@property (nonatomic,retain) NSMutableOrderedSet *extraLayers;
@property (assign,nonatomic) float origWidth;
@property (assign,nonatomic) int pretendVol;
@property (assign,nonatomic) int lastVol;
+(float)volumeStepUpForCurrentVolume:(float)arg1 euVolumeLimit:(float)arg2 ;
+(BOOL)wouldShowAtLeastAYellowBlockForVolume:(float)arg1 euVolumeLimit:(float)arg2 ;
+(float)volumeStepDownForCurrentVolume:(float)arg1 euVolumeLimit:(float)arg2 ;
-(CGColor*)_blockColorForValue:(float)arg1 ;
-(void)_updateBlockView:(id)arg1 value:(float)arg2 blockSize:(CGSize)arg3 point:(CGPoint)arg4 ;
-(void)setHeadphonesPresent:(BOOL)arg1 ;
-(BOOL)headphonesPresent;
-(id)init;
-(void)setProgress:(float)arg1 ;
-(void)setMode:(int)arg1 ;
-(int)mode;
-(float)EUVolumeLimit;
-(void)_updateImage;
-(void)_updateLabels;
-(void)setEUVolumeLimit:(float)arg1 ;
@end
