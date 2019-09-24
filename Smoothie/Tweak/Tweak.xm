%hook SBIconScrollView

-(void)setPagingEnabled:(BOOL)value {
    %orig(NO);
}

%end

%hook SBRootFolderView

-(void)updateIconListIndexAndVisibility:(bool)x {}

-(BOOL)allowsAutoscrollToTodayView {
    return NO;
}

%end