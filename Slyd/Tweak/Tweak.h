#import "../Common.h"
#import <Cephei/HBPreferences.h>

@interface SBDashBoardPasscodeViewController : UIViewController
-(void)performCustomTransitionToVisible:(BOOL)arg1 withAnimationSettings:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)aggregateBehavior:(id)arg1 ;
-(id)displayLayoutElementIdentifier;
-(void)setUseBiometricPresentation:(BOOL)arg1 ;
-(void)setBiometricButtonsInitiallyVisible:(BOOL)arg1 ;

@end

@interface SBDashBoardTodayPageViewController : UIViewController
@end

@interface SBDashBoardComponent : NSObject
+(id)dateView;
-(id)hidden:(BOOL)arg1 ;
@end

@interface SBDashBoardAppearance : NSObject
-(void)addComponent:(id)arg1;
@end

@interface SBDashBoardPageControl : UIView
-(void)stuStateChanged;
@end

@interface SBDashBoardTodayContentView : UIView
-(void)stuStateChanged;
@end

@interface _UILegibilitySettings : NSObject
@property (nonatomic,retain) UIColor * primaryColor; 
@end

@interface SBDashBoardViewController : UIViewController
@property (assign,getter=isAuthenticated,nonatomic) BOOL authenticated;
-(id)_passcodeViewController;
-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 ;
-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 legibilityProvider:(id)arg3 ;
@property (nonatomic,readonly) _UILegibilitySettings * legibilitySettings; 

@end

@interface SBPagedScrollView : UIView
@property (assign,nonatomic) NSUInteger currentPageIndex;
-(BOOL)resetContentOffsetToCurrentPage;
-(void)_layoutScrollView;
-(void)layoutPages;
-(void)layoutSubviews;
-(void)setCurrentPageIndex:(NSUInteger)idx;
-(BOOL)scrollToPageAtIndex:(unsigned long long)arg1 animated:(BOOL)arg2 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)_bs_didEndScrolling;
-(void)_bs_didScrollWithContext:(id)arg1 ;
-(double)pageRelativeScrollOffset;

@end

@interface SBDashBoardMainPageView : UIView
@property (nonatomic, retain) _UIGlintyStringView *stuGlintyStringView;
-(void)stuStateChanged;

@end

@interface SBDashBoardTeachableMomentsContainerViewController : UIViewController
-(void)stuStateChanged;
@end

@interface SBUIPasscodeLockNumberPad : UIView

-(void)setVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_cancelButtonHit;

@end

@interface SBDashBoardFixedFooterViewController : UIViewController {

	NSString* _cachedMesaFailureText;
	BOOL _temporaryMesaFailureTextActive;
	BOOL _authenticatedSinceFingerOn;

}

@property (nonatomic,readonly) UIView * fixedFooterView;
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy,readonly) NSString * description;
@property (copy,readonly) NSString * debugDescription;
+(Class)viewClass;
-(void)dashBoardStatusTextViewControllerContentDidChange:(id)arg1 ;
-(UIView *)fixedFooterView;
-(void)updateCallToActionForMesaMatchFailure;
-(void)_addCallToAction;
-(void)_addStatusTextViewControllerIfNecessary;
-(void)_updateCallToActionTextAnimated:(BOOL)arg1 ;
-(id)init;
-(BOOL)handleEvent:(id)arg1 ;
-(void)viewDidLoad;
-(void)viewWillAppear:(BOOL)arg1 ;
-(void)viewDidAppear:(BOOL)arg1 ;
-(void)viewDidDisappear:(BOOL)arg1 ;
-(void)stuStateChanged;
@end

@interface SBCoverSheetSlidingViewController : UIViewController

-(void)_handleDismissGesture:(id)arg1 ;
-(void)setPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3 ;

@end

@interface SBCoverSheetPrimarySlidingViewController : SBCoverSheetSlidingViewController

@end

@interface SBLockScreenManager : NSObject

@property (readonly) BOOL isUILocked;                                                                                                                     //@synthesize isUILocked=_isUILocked - In the implementation block
@property (readonly) BOOL isWaitingToLockUI;                                                                                                              //@synthesize isWaitingToLockUI=_isWaitingToLockUI - In the implementation block
@property (readonly) BOOL shouldHandlePocketStateChanges;
@property (readonly) BOOL shouldPlayLockSound;
@property (readonly) BOOL isLockScreenActive;
@property (readonly) BOOL isLockScreenVisible;
@property (readonly) BOOL bioAuthenticatedWhileMenuButtonDown;

+(Class)safeCategoryBaseClass;
+(id)_sharedInstanceCreateIfNeeded:(BOOL)arg1 ;
+(id)sharedInstance;
+(id)sharedInstanceIfExists;
-(BOOL)isUILocked;
-(BOOL)hasUIEverBeenLocked;
-(void)loadViewsIfNeeded;
-(BOOL)isInLostMode;
-(void)_noteStartupTransitionWillBegin;
-(void)_noteStartupTransitionDidBegin;
-(void)_setIdleTimerCoordinator:(id)arg1 ;
-(id)coordinatorRequestedIdleTimerDescriptor:(id)arg1 ;
-(id)idleTimerProvider:(id)arg1 didProposeDescriptor:(id)arg2 forReason:(id)arg3 ;
-(BOOL)unlockUIFromSource:(int)arg1 withOptions:(id)arg2 ;
-(BOOL)shouldPlayLockSound;
-(BOOL)isLockScreenActive;
-(id)_lockOutController;
-(void)wallpaperDidChangeForVariant:(long long)arg1 ;
-(void)setPasscodeVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(BOOL)handleTransitionRequest:(id)arg1 ;
-(BOOL)isUIUnlocking;
-(void)attemptUnlockWithPasscode:(id)arg1 ;
-(BOOL)_attemptUnlockWithPasscode:(id)arg1 finishUIUnlock:(BOOL)arg2 ;
-(BOOL)shouldLockUIAfterEndingCall;
-(void)alertDidDeactivate:(id)arg1 ;
-(void)remoteLock:(BOOL)arg1 ;
-(void)_setMesaUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)tapToWakeControllerDidRecognizeWakeGesture:(id)arg1 ;
-(void)enableLostModePlugin;
-(void)_setLockOutController:(id)arg1 ;
-(void)dashBoardViewController:(id)arg1 requestsTouchIDDisabled:(BOOL)arg2 forReason:(id)arg3 ;
-(void)dashBoardViewController:(id)arg1 unlockWithRequest:(id)arg2 completion:(/*^block*/id)arg3 ;
-(BOOL)_canHandleTransitionRequest:(id)arg1 ;
-(void)dashBoardViewControllerIrisPlayingDidFinish:(id)arg1 ;
-(BOOL)isLockScreenDisabledForAssertion;
-(void)addLockScreenDisableAssertion:(id)arg1 ;
-(void)removeLockScreenDisableAssertion:(id)arg1 ;
-(void)noteMenuButtonSinglePress;
-(BOOL)handlesHomeButtonSinglePresses;
-(void)noteMenuButtonDoublePress;
-(void)coverSheetPresentationManager:(id)arg1 unlockWithRequest:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)lockScreenViewControllerWillPresent;
-(void)lockScreenViewControllerDidPresent;
-(void)lockScreenViewControllerWillDismiss;
-(void)lockScreenViewControllerDidDismiss;
-(void)lockScreenViewControllerRequestsUnlock;
-(void)homeButtonShowPasscodeRecognizerDidFailToRecognize:(id)arg1 ;
-(void)homeButtonShowPasscodeRecognizerRequestsPasscodeUIToBeShown:(id)arg1 ;
-(void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)attemptUnlockWithPasscode:(id)arg1 completion:(/*^block*/id)arg2 ;
-(id)biometricAuthenticationCoordinator;
-(BOOL)biometricAuthenticationCoordinator:(id)arg1 requestsAuthenticationFeedback:(id)arg2 ;
-(BOOL)biometricAuthenticationCoordinator:(id)arg1 requestsUnlockWithIntent:(int)arg2 ;
-(BOOL)bioAuthenticatedWhileMenuButtonDown;
-(void)_setupModeChanged;
-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 completion:(/*^block*/id)arg3 ;
-(BOOL)passcodeEntryAlertViewController:(id)arg1 authenticatePasscode:(id)arg2 ;
-(void)passcodeEntryAlertViewControllerWantsEmergencyCall:(id)arg1 ;
-(void)updateSpringBoardStatusBarForLockScreenTeardown;
-(BOOL)isPasscodeEntryAlertVisible;
-(BOOL)isLockScreenVisible;
-(void)homeButtonSuppressAfterUnlockRecognizerRequestsEndOfSuppression:(id)arg1 ;
-(BOOL)isWaitingToLockUI;
-(id)_newLockScreenController;
-(void)_reallySetUILocked:(BOOL)arg1 ;
-(void)activationChanged:(id)arg1 ;
-(BOOL)_lockUI;
-(void)_deviceBlockedChanged:(id)arg1 ;
-(void)_resetOrRestoreStateChanged:(id)arg1 ;
-(void)_lockScreenDimmed:(id)arg1 ;
-(void)_handleBacklightLevelWillChange:(id)arg1 ;
-(void)_handleBacklightDidTurnOff:(id)arg1 ;
-(void)_activeCallStateChanged;
-(void)_setUserAuthController:(id)arg1 ;
-(void)_evaluatePreArmDisabledAssertions;
-(BOOL)_shouldLockAfterEndingTelephonyCall;
-(BOOL)_shouldLockAfterEndingFaceTimeCall;
-(void)_disconnectActiveCallIfNeededFromSource:(int)arg1 ;
-(void)_activateLockScreenAnimated:(BOOL)arg1 animationProvider:(/*^block*/id)arg2 automatically:(BOOL)arg3 inScreenOffMode:(BOOL)arg4 dimInAnimation:(BOOL)arg5 dismissNotificationCenter:(BOOL)arg6 completion:(/*^block*/id)arg7 ;
-(void)_clearAuthenticationLockAssertion;
-(void)_relockUIForButtonlikeSource:(int)arg1 afterCall:(BOOL)arg2 ;
-(void)_prepareWallpaperForLockedMode;
-(void)setUIUnlocking:(BOOL)arg1 ;
-(void)_setHomeButtonSuppressAfterUnlockRecognizer:(id)arg1 ;
-(void)_setUILocked:(BOOL)arg1 ;
-(void)_sendUILockStateChangedNotification;
-(void)_runUnlockActionBlock:(BOOL)arg1 ;
-(void)_prepareWallpaperForUnlockedMode;
-(BOOL)_unlockWithRequest:(id)arg1 cancelPendingRequests:(BOOL)arg2 completion:(/*^block*/id)arg3 ;
-(void)_setWalletPreArmDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(BOOL)_attemptUnlockWithPasscode:(id)arg1 mesa:(BOOL)arg2 finishUIUnlock:(BOOL)arg3 ;
-(BOOL)_isPasscodeVisible;
-(void)_handleAuthenticationFeedback:(id)arg1 ;
-(BOOL)_setPasscodeVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_setHomeButtonShowPasscodeRecognizer:(id)arg1 ;
-(void)_resetDashBoardInterfaceOrientationAnimated:(BOOL)arg1 ;
-(void)_postLockCompletedNotification:(BOOL)arg1 ;
-(void)_setMesaCoordinatorDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)_createAuthenticationAssertion;
-(BOOL)_isUnlockDisabled;
-(BOOL)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 ;
-(void)_setMesaAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(BOOL)_canAttemptRealUIUnlockIgnoringBacklightNonsenseWithReason:(out id*)arg1 ;
-(BOOL)_attemptUnlockWithPasscode:(id)arg1 mesa:(BOOL)arg2 finishUIUnlock:(BOOL)arg3 completion:(/*^block*/id)arg4 ;
-(void)_lockFeaturesForRemoteLock:(BOOL)arg1 ;
-(void)exitLostModeIfNecessaryFromRemoteRequest:(BOOL)arg1 ;
-(void)_maybeLaunchSetupForcingCheckIfNotBricked:(BOOL)arg1 ;
-(BOOL)_shouldUnlockUIOnKeyDownEvent;
-(id)averageColorForCurrentWallpaperInScreenRect:(CGRect)arg1 ;
-(BOOL)shouldHandlePocketStateChanges;
-(void)startUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 ;
-(void)attemptUnlockWithMesa;
-(void)activateLostModeForRemoteLock:(BOOL)arg1 ;
-(BOOL)_shouldBeInSetupMode;
-(id)_userAuthController;
-(id)_liftToWakeManager;
-(void)_setLiftToWakeManager:(id)arg1 ;
-(id)_tapToWakeController;
-(void)_setTapToWakeController:(id)arg1 ;
-(id)unlockActionBlock;
-(void)setUnlockActionBlock:(id)arg1 ;
-(id)init;
-(NSString *)description;
-(void)extendedKeybagLockStateChanged:(BOOL)arg1 ;
-(BOOL)unlockWithRequest:(id)arg1 completion:(/*^block*/id)arg2 ;
-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 ;
-(void)_authenticationStateChanged:(id)arg1 ;
-(id)succinctDescription;
-(id)descriptionWithMultilinePrefix:(id)arg1 ;
-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
-(id)succinctDescriptionBuilder;
@end
