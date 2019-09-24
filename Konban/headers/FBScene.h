#import "FBSMutableSceneSettings.h"
#import "FBSceneHostManager.h"

@interface FBScene : NSObject

@property (nonatomic,retain) FBSMutableSceneSettings * mutableSettings;                  //@synthesize mutableSettings=_mutableSettings - In the implement
@property (nonatomic,readonly) FBSceneHostManager * hostManager;                         //@synthesize hostManager=_hostManager - In the implementation block


-(id)createSnapshot;
-(unsigned long long)_beginTransaction;
-(id)createSnapshotWithContext:(id)arg1 ;
-(void)_addSceneGeometryObserver:(id)arg1 ;
-(void)_removeSceneGeometryObserver:(id)arg1 ;
-(unsigned long long)_transactionID;
-(void)client:(id)arg1 attachLayer:(id)arg2 ;
-(void)client:(id)arg1 updateLayer:(id)arg2 ;
-(void)client:(id)arg1 detachLayer:(id)arg2 ;
-(void)client:(id)arg1 didUpdateClientSettings:(id)arg2 withDiff:(id)arg3 transitionContext:(id)arg4 ;
-(void)client:(id)arg1 didReceiveActions:(id)arg2 ;
-(void)clientWillInvalidate:(id)arg1 ;
-(void)updateUISettingsWithTransitionBlock:(/*^block*/id)arg1 ;
-(void)updateSettingsWithTransitionBlock:(/*^block*/id)arg1 ;
-(void)updateUISettingsWithBlock:(/*^block*/id)arg1 ;
-(long long)currentInterfaceOrientation;
-(void)updateSettings:(id)arg1 withTransitionContext:(id)arg2 ;
-(FBSMutableSceneSettings *)mutableSettings;
-(NSString *)workspaceIdentifier;
-(id)initWithDefiniton:(id)arg1 initialParameters:(id)arg2 clientProvider:(id)arg3 ;
-(BOOL)_isInTransaction;
-(void)setMutableSettings:(FBSMutableSceneSettings *)arg1 ;
-(void)_applyUpdateWithContext:(id)arg1 completion:(/*^block*/id)arg2 ;
-(void)_endTransaction:(unsigned long long)arg1 ;
-(void)_invalidateWithTransitionContext:(id)arg1 ;
-(void)updateSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)_dispatchClientMessageWithBlock:(/*^block*/id)arg1 ;
-(id)succinctDescription;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(id)succinctDescriptionBuilder;
-(void)dealloc;
-(NSString *)identifier;
-(NSString *)description;
-(NSString *)debugDescription;
-(id)contentView;
-(FBSSceneSettings *)settings;
-(id)uiSettings;
-(id)uiClientSettings;
-(BOOL)isValid;
-(void)updateSettingsWithBlock:(/*^block*/id)arg1 ;
-(void)sendActions:(id)arg1 ;
-(id)snapshotContext;
@end
