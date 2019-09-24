@interface SBUIController : NSObject

+(instancetype)sharedInstanceIfExists;
-(BOOL)isOnAC;

@end

@interface SBMediaController : NSObject

+(id)sharedInstance;
-(BOOL)isPlaying;
-(BOOL)isPaused;

@end