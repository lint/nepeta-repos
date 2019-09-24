#import "../headers/FBScene.h"
#import "../headers/SBApplication.h"
#import "../headers/SBApplicationController.h"

@interface UIApplication(Private)

-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;

@end

@interface Konban : NSObject

+(SBApplication *)app:(NSString *)bundleID;
+(UIView *)viewFor:(NSString *)bundleID;
+(void)launch:(NSString *)bundleID;
+(void)forceBackgrounded:(BOOL)backgrounded forApp:(SBApplication *)app;
+(void)rehost:(NSString *)bundleID;
+(void)dehost:(NSString *)bundleID;

@end