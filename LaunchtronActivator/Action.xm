#import <UIKit/UIKit.h>
#import <libactivator/libactivator.h>
#import "Action.h"

static LaunchtronListener* listener = nil;

@implementation LaunchtronListener

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)LTOpenNotification, nil, nil, true);
}

@end

%ctor {
    listener = [[LaunchtronListener alloc] init];
	[[LAActivator sharedInstance] registerListener:listener forName:@"me.nepeta.launchtron.listener"];
}