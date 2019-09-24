@interface FBSceneHostManager : NSObject

@property (nonatomic,copy) NSString * identifier;                                         //@synthesize identifier=_identifier - In the implementation block
@property (getter=isInvalidated,nonatomic,readonly) BOOL invalidated;                     //@synthesize invalidated=_invalidated - In the implementation block
@property (nonatomic,readonly) long long contentState;                                    //@synthesize contentState=_contentState - In the implementation block
@property (assign,nonatomic) BOOL defaultClippingDisabled;                                //@synthesize defaultClippingDisabled=_defaultClippingDisabled - In the implementation block
@property (assign,nonatomic) CGAffineTransform defaultHostViewTransform;                  //@synthesize defaultHostViewTransform=_defaultHostViewTransform - In the implementation block
@property (nonatomic,copy) UIColor * defaultBackgroundColorWhileHosting; 
@property (nonatomic,copy) UIColor * defaultBackgroundColorWhileNotHosting; 
@property (assign,nonatomic) unsigned long long defaultHostedLayerTypes;                  //@synthesize defaultHostedLayerTypes=_defaultHostedLayerTypes - In the implementation block
@property (assign,nonatomic) unsigned long long defaultRenderingMode;                     //@synthesize defaultRenderingMode=_defaultRenderingMode - In the implementation block
@property (nonatomic,copy) NSString * defaultMinificationFilterName;                      //@synthesize defaultMinificationFilterName=_defaultMinificationFilterName - In the implementation block
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(void)setDefaultClippingDisabled:(BOOL)arg1 ;
-(void)setDefaultHostViewTransform:(CGAffineTransform)arg1 ;
-(void)setDefaultHostedLayerTypes:(unsigned long long)arg1 ;
-(void)setDefaultRenderingMode:(unsigned long long)arg1 ;
-(void)setDefaultMinificationFilterName:(NSString *)arg1 ;
-(id)_wrapperViewForRequester:(id)arg1 ;
-(id)_hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2 ;
-(void)enableHostingForRequester:(id)arg1 priority:(long long)arg2 ;
-(id)_overrideRequesterIfNecessary:(id)arg1 ;
-(void)_updateActiveHostRequester;
-(void)disableHostingForRequester:(id)arg1 ;
-(void)_callOutToObservers:(/*^block*/id)arg1 ;
-(void)setLayer:(id)arg1 hidden:(BOOL)arg2 forRequester:(id)arg3 ;
-(id)_hostViewForRequester:(id)arg1 ;
-(id)snapshotContextForRequester:(id)arg1 ;
-(id)_snapshotContextForFrame:(CGRect)arg1 excludedContextIDs:(id)arg2 opaque:(BOOL)arg3 outTransform:(CGAffineTransform*)arg4 ;
-(id)snapshotViewWithContext:(id)arg1 ;
-(id)_activeHostRequester;
-(void)_activateRequester:(id)arg1 ;
-(void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2 ;
-(id)_snapshotContextForFrame:(CGRect)arg1 excludedLayers:(id)arg2 opaque:(BOOL)arg3 ;
-(id)initWithLayerManager:(id)arg1 scene:(id)arg2 ;
-(BOOL)defaultClippingDisabled;
-(CGAffineTransform)defaultHostViewTransform;
-(void)setDefaultBackgroundColorWhileHosting:(UIColor *)arg1 ;
-(UIColor *)defaultBackgroundColorWhileHosting;
-(void)setDefaultBackgroundColorWhileNotHosting:(UIColor *)arg1 ;
-(UIColor *)defaultBackgroundColorWhileNotHosting;
-(id)hostViewForRequester:(id)arg1 ;
-(id)hostViewForRequester:(id)arg1 appearanceStyle:(unsigned long long)arg2 ;
-(id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2 ;
-(id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2 appearanceStyle:(unsigned long long)arg3 ;
-(void)orderRequesterFront:(id)arg1 ;
-(void)setContextId:(unsigned)arg1 hidden:(BOOL)arg2 forRequester:(id)arg3 ;
-(void)setLayer:(id)arg1 alpha:(double)arg2 forRequester:(id)arg3 ;
-(id)disableHostingForReason:(id)arg1 ;
-(id)snapshotViewForSnapshot:(id)arg1 ;
-(id)snapshotViewWithFrame:(CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3 ;
-(id)snapshotUIImageForFrame:(CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3 outTransform:(CGAffineTransform*)arg4 ;
-(CGImageRef)snapshotCGImageRefForFrame:(CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3 outTransform:(CGAffineTransform*)arg4 ;
-(IOSurfaceRef)snapshotIOSurfaceForFrame:(CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3 outTransform:(CGAffineTransform*)arg4 ;
-(void)_setContentState:(long long)arg1 ;
-(unsigned long long)defaultHostedLayerTypes;
-(unsigned long long)defaultRenderingMode;
-(NSString *)defaultMinificationFilterName;
-(long long)contentState;
-(id)succinctDescription;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(id)succinctDescriptionBuilder;
-(void)dealloc;
-(NSString *)identifier;
-(NSString *)description;
-(void)removeObserver:(id)arg1 ;
-(void)setIdentifier:(NSString *)arg1 ;
-(void)invalidate;
-(void)addObserver:(id)arg1 ;
-(BOOL)isInvalidated;
@end
