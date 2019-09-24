void LTNotify() {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)LTNotification, nil, nil, true);
}