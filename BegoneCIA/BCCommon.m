void BCSetState(BOOL state) {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:BCPreferencesIdentifier];
    [preferences setBool:state forKey:BCEnabled];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)BCNotification, nil, nil, true);
}

bool BCGetState() {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:BCPreferencesIdentifier];
	return [([preferences objectForKey:BCEnabled] ?: @(false)) boolValue];
}

void BCNotifyAppChange() {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)BCNotificationAppChange, nil, nil, true);
}

void BCNotifyDisableMSD() {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)BCNotificationMSDDisable, nil, nil, true);
}

void BCNotifyEnableMSD() {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)BCNotificationMSDEnable, nil, nil, true);
}