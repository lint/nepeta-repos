#define KEY @"_NepetaIconState"

%hook SBDefaultIconModelStore

-(id)loadCurrentIconState:(id*)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:KEY]) {
        return [defaults objectForKey:KEY];
    }

    id orig = %orig;
    [defaults setObject:orig forKey:KEY];
    return orig;
}

-(BOOL)saveCurrentIconState:(id)state error:(id*)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:state forKey:KEY];
    return %orig;
}

%end