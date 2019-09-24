#import "Tweak.h"

static NSDictionary *replacement = @{
    @"r": @"w",
    @"l": @"w",
    @"R": @"W",
    @"L": @"W",
    @"ow": @"OwO",
    @"no": @"nu",
    @"has": @"haz",
    @"have": @"haz",
    @"you": @"uu",
    @"the ": @"da "
};

static NSString *mode = nil;

NSString *owoify (NSString *text) {
    NSString *temp = [text copy];
    
    if (replacement) {
        for (NSString *key in replacement) {
            temp = [temp stringByReplacingOccurrencesOfString:key withString:replacement[key]];
        }
    }

    return [@" " stringByAppendingString:temp];
}

%group SelectOwO

%hook UICalloutBar

%property (nonatomic, retain) UIMenuItem *slcOwOItem;

-(id)initWithFrame:(CGRect)arg1 {
    UICalloutBar *orig = %orig;

    self.slcOwOItem = [[UIMenuItem alloc] initWithTitle:@"OwO" action:@selector(slcOwO:)];

    return orig;
}

-(void)updateAvailableButtons {
    %orig;

    if (!self.extraItems) {
        self.extraItems = @[];
    }

    bool display = false;
    NSArray *currentSystemButtons = MSHookIvar<NSArray *>(self, "m_currentSystemButtons");

    for (UICalloutBarButton *btn in currentSystemButtons) {
        if (btn.action == @selector(cut:)) {
            display = true;
        }
    }

    NSMutableArray *items = [self.extraItems mutableCopy];

    if (display) {
        if (![items containsObject:self.slcOwOItem]) {
            [items addObject:self.slcOwOItem];
        }
    } else {
        [items removeObject:self.slcOwOItem];
    }

    self.extraItems = items;

    %orig;
}

%end

%hook UIResponder

%new
-(void)slcOwO:(UIResponder *)sender {
    NSString *originalText = [[UIPasteboard generalPasteboard].string copy];
    [[UIApplication sharedApplication] sendAction:@selector(cut:) to:nil from:self forEvent:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString *selectedText = [[UIPasteboard generalPasteboard].string copy];

        if (selectedText) {
            [[UIPasteboard generalPasteboard] setString:owoify(selectedText)];
            [[UIApplication sharedApplication] sendAction:@selector(paste:) to:nil from:self forEvent:nil];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (originalText) {
                [[UIPasteboard generalPasteboard] setString:originalText];
            } else {
                [[UIPasteboard generalPasteboard] setString:@""];
            }
        });
    });
}

%end

%end


%ctor {
    // Someone smarter than me invented this.
    // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
    bool shouldLoad = NO;
    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString *executablePath = args[0];
        if (executablePath) {
            NSString *processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if (!isFileProvider && isApplication && !skip) {
                shouldLoad = YES;
            }
        }
    }

    if (!shouldLoad) return;

    %init(SelectOwO);
}