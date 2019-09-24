#import "CBDManager.h"
#import "Tweak.h"

@implementation CBDManager

+(instancetype)sharedInstance {
	static CBDManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [CBDManager alloc];
		sharedInstance.defaults = [NSUserDefaults standardUserDefaults];
		sharedInstance.savedLayouts = [NSMutableDictionary new];
		[sharedInstance load];
	});
	return sharedInstance;
}

-(id)init {
	return [CBDManager sharedInstance];
}

-(void)load {
	self.hideIconLabels = [self.defaults boolForKey:@"hideIconLabels"];
	self.hideIconDots = [self.defaults boolForKey:@"hideIconDots"];
	self.homescreenColumns = [self.defaults integerForKey:@"homescreenColumns"];
	self.homescreenRows = [self.defaults integerForKey:@"homescreenRows"];
	self.verticalOffset = [self.defaults floatForKey:@"verticalOffset"];
	self.horizontalOffset = [self.defaults floatForKey:@"horizontalOffset"];
	self.verticalPadding = [self.defaults floatForKey:@"verticalPadding"];
	self.horizontalPadding = [self.defaults floatForKey:@"horizontalPadding"];

	NSDictionary *savedLayouts = [self.defaults objectForKey:@"savedLayouts"];
	if (savedLayouts && [savedLayouts isKindOfClass:[NSDictionary class]]) {
		self.savedLayouts = [savedLayouts mutableCopy];
	}
}

-(void)save {
	[self.defaults setBool:self.hideIconLabels forKey:@"hideIconLabels"];
	[self.defaults setBool:self.hideIconDots forKey:@"hideIconDots"];
	[self.defaults setInteger:self.homescreenColumns forKey:@"homescreenColumns"];
	[self.defaults setInteger:self.homescreenRows forKey:@"homescreenRows"];
	[self.defaults setFloat:self.verticalOffset forKey:@"verticalOffset"];
	[self.defaults setFloat:self.horizontalOffset forKey:@"horizontalOffset"];
	[self.defaults setFloat:self.verticalPadding forKey:@"verticalPadding"];
	[self.defaults setFloat:self.horizontalPadding forKey:@"horizontalPadding"];
	[self.defaults setObject:self.savedLayouts forKey:@"savedLayouts"];
	[self.defaults synchronize];
}

-(void)reset {
	self.hideIconLabels = NO;
	self.hideIconDots = NO;
	self.homescreenColumns = 0;
	self.homescreenRows = 0;
	self.verticalOffset = 0;
	self.horizontalOffset = 0;
	self.verticalPadding = 0;
	self.horizontalPadding = 0;
	[self save];
	[self relayoutAllAnimated];
}

-(void)relayout {
	SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
	SBRootIconListView *listView = [iconController rootIconListAtIndex:[iconController currentIconListIndex]];
	[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[listView layoutIconsNow];
	} completion:NULL];
}

-(void)relayoutAll {
	SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
	[iconController relayout];
	[self.view.superview bringSubviewToFront:self.view];
}

-(void)relayoutAllAnimated {
	SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
	SBRootIconListView *listView = [iconController rootIconListAtIndex:[iconController currentIconListIndex]];
	[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[listView layoutIconsNow];
	} completion:^(BOOL whatever) {
		[iconController relayout];
		[self.view.superview bringSubviewToFront:self.view];
	}];
}

-(void)loadLayoutWithName:(NSString *)name {
	if (!self.savedLayouts[name]) return;
	NSDictionary *layout = self.savedLayouts[name];
	self.hideIconLabels      = layout[@"hideIconLabels"]      ? [layout[@"hideIconLabels"] isEqualToString:@"YES"]  : NO;
	self.hideIconDots        = layout[@"hideIconDots"]        ? [layout[@"hideIconDots"] isEqualToString:@"YES"]    : NO;
	self.homescreenColumns   = layout[@"homescreenColumns"]   ? [layout[@"homescreenColumns"] intValue]             : 0;
	self.homescreenRows      = layout[@"homescreenRows"]      ? [layout[@"homescreenRows"] intValue]                : 0;
	self.verticalOffset      = layout[@"verticalOffset"]      ? [layout[@"verticalOffset"] floatValue]              : 0;
	self.horizontalOffset    = layout[@"horizontalOffset"]    ? [layout[@"horizontalOffset"] floatValue]            : 0;
	self.verticalPadding     = layout[@"verticalPadding"]     ? [layout[@"verticalPadding"] floatValue]             : 0;
	self.horizontalPadding   = layout[@"horizontalPadding"]   ? [layout[@"horizontalPadding"] floatValue]           : 0;
	[self relayoutAllAnimated];
}

-(NSDictionary *)currentSettingsAsDictionary {
	return @{
		@"hideIconLabels": self.hideIconLabels ? @"YES" : @"NO",
		@"hideIconDots": self.hideIconDots ? @"YES" : @"NO",
		@"homescreenColumns": [NSString stringWithFormat:@"%lu", (unsigned long)self.homescreenColumns],
		@"homescreenRows": [NSString stringWithFormat:@"%lu", (unsigned long)self.homescreenRows],
		@"verticalOffset": [NSString stringWithFormat:@"%.1f", self.verticalOffset],
		@"horizontalOffset": [NSString stringWithFormat:@"%.1f", self.horizontalOffset],
		@"verticalPadding": [NSString stringWithFormat:@"%.1f", self.verticalPadding],
		@"horizontalPadding": [NSString stringWithFormat:@"%.1f", self.horizontalPadding],
	};
}

-(NSString *)layoutDescription:(NSDictionary *)layout {
	return [NSString stringWithFormat:@"Hide icon labels: %@\nHomescreen columns: %@\nHomescreen rows: %@\nVertical offset: %@\nHorizontal offset: %@\nVertical padding: %@\nHorizontal padding: %@",
		layout[@"hideIconLabels"],
		layout[@"homescreenColumns"],
		layout[@"homescreenRows"],
		layout[@"verticalOffset"],
		layout[@"horizontalOffset"],
		layout[@"verticalPadding"],
		layout[@"horizontalPadding"]
	];
}

-(void)saveLayoutWithName:(NSString *)name {
	self.savedLayouts[name] = [self currentSettingsAsDictionary];
	[self save];
}

-(void)deleteLayoutWithName:(NSString *)name {
	[self.savedLayouts removeObjectForKey:name];
	[self save];
}

-(void)renameLayoutWithName:(NSString *)name toName:(NSString *)newName {
	self.savedLayouts[newName] = self.savedLayouts[name];
	[self.savedLayouts removeObjectForKey:name];
	[self save];
}

-(void)deleteAllLayouts {
	self.savedLayouts = [NSMutableDictionary new];
	[self save];
}

-(void)stopEditing {
	SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
	[iconController setIsEditing:NO];
}

-(void)presentViewController:(UIViewController*)viewController animated:(BOOL)animated completion:(id)completion {
	SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
	[iconController presentViewController:viewController animated:animated completion:completion];
}

@end