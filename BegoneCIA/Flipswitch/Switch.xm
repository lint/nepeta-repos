#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "../BCCommon.h"

@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface BCFlipswitch : NSObject <FSSwitchDataSource>
@end

@implementation BCFlipswitch

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
	return @"BegoneCIA";
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
	return (BCGetState()) ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	switch (newState) {
	case FSSwitchStateIndeterminate:
		break;
	case FSSwitchStateOn:
		BCSetState(true);
		break;
	case FSSwitchStateOff:
		BCSetState(false);
		break;
	}
	return;
}

@end
