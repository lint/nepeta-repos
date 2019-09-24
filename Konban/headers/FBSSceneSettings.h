@interface FBSSceneSettings : NSObject

//@property (nonatomic,copy,readonly) FBSDisplayIdentity * displayIdentity; 
//@property (nonatomic,copy,readonly) FBSDisplayConfiguration * displayConfiguration;              //@synthesize displayConfiguration=_displayConfiguration - In the implementation block
@property (nonatomic,readonly) CGRect frame;                                                     //@synthesize frame=_frame - In the implementation block
@property (nonatomic,readonly) double level;                                                     //@synthesize level=_level - In the implementation block
@property (nonatomic,readonly) long long interfaceOrientation;                                   //@synthesize interfaceOrientation=_interfaceOrientation - In the implementation block
@property (getter=isBackgrounded,nonatomic,readonly) BOOL backgrounded;                          //@synthesize backgrounded=_backgrounded - In the implementation block
@property (nonatomic,copy,readonly) NSArray * occlusions;                                        //@synthesize occlusions=_occlusions - In the implementation block
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
+(BOOL)_isMutable;
+(id)settings;
-(id)debugDescriptionWithMultilinePrefix:(id)arg1 ;
-(id)transientLocalSettings;
-(id)_descriptionBuilderWithMultilinePrefix:(id)arg1 debug:(BOOL)arg2 ;
-(id)ignoreOcclusionReasons;
-(NSArray *)occlusions;
-(BOOL)isIgnoringOcclusions;
-(id)succinctDescription;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(id)succinctDescriptionBuilder;
-(id)init;
-(void)dealloc;
-(BOOL)isEqual:(id)arg1 ;
-(CGRect)bounds;
-(unsigned long long)hash;
-(NSString *)description;
-(NSString *)debugDescription;
-(id)copyWithZone:(NSZone*)arg1 ;
-(long long)interfaceOrientation;
-(CGRect)frame;
-(id)mutableCopyWithZone:(NSZone*)arg1 ;
-(id)initWithSettings:(id)arg1 ;
-(BOOL)isBackgrounded;
-(BOOL)isOccluded;
-(double)level;
-(id)keyDescriptionForSetting:(unsigned long long)arg1 ;
-(id)valueDescriptionForFlag:(long long)arg1 object:(id)arg2 ofSetting:(unsigned long long)arg3 ;
-(id)otherSettings;
@end