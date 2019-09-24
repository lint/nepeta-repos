#import "FBSSceneSettings.h"

@interface FBSMutableSceneSettings : FBSSceneSettings

@property (nonatomic,copy) NSArray * occlusions; 
@property (assign,nonatomic) CGRect frame; 
@property (assign,nonatomic) double level; 
@property (assign,nonatomic) long long interfaceOrientation; 
@property (assign,getter=isBackgrounded,nonatomic) BOOL backgrounded; 
+(BOOL)_isMutable;
-(void)_setDisplayConfiguration:(id)arg1 ;
-(id)transientLocalSettings;
-(id)ignoreOcclusionReasons;
-(void)setOcclusions:(NSArray *)arg1 ;
-(void)setFrame:(CGRect)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(id)mutableCopyWithZone:(NSZone*)arg1 ;
-(void)setLevel:(double)arg1 ;
-(void)setInterfaceOrientation:(long long)arg1 ;
-(id)otherSettings;
-(void)setBackgrounded:(BOOL)arg1 ;
-(void)setDisplayConfiguration:(id)arg1 ;
@end