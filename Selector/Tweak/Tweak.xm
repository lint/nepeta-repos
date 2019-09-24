#import <Cephei/HBPreferences.h>
#import "Tweak.h"
#import "SLCWindow.h"

HBPreferences *preferences;
SLCWindow *slcWindow = nil;

bool enabled;
bool searchEnabled;
bool searchPopup;
NSString *searchEngine;
bool translationEnabled;
bool translationPopup;
NSString *translationService;
NSString *translationLanguage;

%group Selector

%hook UICalloutBar

%property (nonatomic, retain) UIMenuItem *slcTranslateItem;
%property (nonatomic, retain) UIMenuItem *slcSearchItem;

-(id)initWithFrame:(CGRect)arg1 {
    UICalloutBar *orig = %orig;

    self.slcTranslateItem = [[UIMenuItem alloc] initWithTitle:@"Translate" action:@selector(slcTranslate:)];
    self.slcSearchItem = [[UIMenuItem alloc] initWithTitle:@"Search" action:@selector(slcSearch:)];

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
        if (btn.action == @selector(copy:)) {
            display = true;
        }
    }

    NSMutableArray *items = [self.extraItems mutableCopy];

    if (display) {
        if (![items containsObject:self.slcTranslateItem]) {
            [items addObject:self.slcTranslateItem];
        }

        if (![items containsObject:self.slcSearchItem]) {
            [items addObject:self.slcSearchItem];
        }
    } else {
        [items removeObject:self.slcTranslateItem];
        [items removeObject:self.slcSearchItem];
    }

    if (!enabled || !translationEnabled) [items removeObject:self.slcTranslateItem];
    if (!enabled || !searchEnabled) [items removeObject:self.slcSearchItem];

    self.extraItems = items;

    %orig;
}

%end

%hook UIResponder

%new
-(void)slcSelectedText:(void (^)(NSString *))callback {
    NSString *originalText = [[UIPasteboard generalPasteboard].string copy];
    [[UIApplication sharedApplication] sendAction:@selector(copy:) to:nil from:self forEvent:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString *selectedText = [[UIPasteboard generalPasteboard].string copy];

        NSLog(@"[Selector] selected = %@", selectedText);

        if (selectedText) {
            callback(selectedText);
        }

        if (originalText) {
            [[UIPasteboard generalPasteboard] setString:originalText];
        } else {
            [[UIPasteboard generalPasteboard] setString:@""];
        }
    });
}

%new
-(void)slcOpenUrl:(NSString *)url withParameter:(NSString *)parameter popup:(bool)popup {
    if (!slcWindow) {
        slcWindow = [[SLCWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    NSString *strUrl = [url stringByReplacingOccurrencesOfString:@"%s" withString: [parameter stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLHostAllowedCharacterSet]];

    if (popup && [strUrl hasPrefix:@"http"]) {
        NSLog(@"[Selector] url = %@", strUrl);
        [slcWindow open:strUrl];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strUrl] options:@{} completionHandler:nil];
    }
}

%new
-(void)slcTranslate:(UIResponder *)sender {
    [self slcSelectedText:^(NSString *selectedText) {
        NSString *language = @"en";

        if ([translationLanguage isEqualToString:@"system"]) {
            language = [[NSLocale preferredLanguages] firstObject];
        } else {
            language = translationLanguage;
        }

        [self slcOpenUrl:[translationService stringByReplacingOccurrencesOfString:@"%l" withString:language] withParameter:selectedText popup:translationPopup];
    }];
}

%new
-(void)slcSearch:(id)sender {
    [self slcSelectedText:^(NSString *selectedText) {
        [self slcOpenUrl:searchEngine withParameter:selectedText popup:searchPopup];
    }];
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

    preferences = [[HBPreferences alloc] initWithIdentifier:@"me.nepeta.selector"];
    [preferences registerDefaults:@{
        @"Enabled": @YES,
        @"TranslationEnabled": @YES,
        @"TranslationPopup": @YES,
        @"TranslationLanguage": @"auto",
        @"TranslationService": @"https://translate.google.com/?vi=c#auto/%l/%s",
        @"SearchEnabled": @YES,
        @"SearchPopup": @NO,
        @"SearchEngine": @"https://www.google.com/search?q=%s",
    }];

    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerBool:&translationEnabled default:YES forKey:@"TranslationEnabled"];
    [preferences registerBool:&searchEnabled default:YES forKey:@"SearchEnabled"];
    [preferences registerBool:&translationPopup default:YES forKey:@"TranslationPopup"];
    [preferences registerBool:&searchPopup default:NO forKey:@"SearchPopup"];
    [preferences registerObject:&translationLanguage default:@"auto" forKey:@"TranslationLanguage"];
    [preferences registerObject:&translationService default:@"https://translate.google.com/?vi=c#auto/%l/%s" forKey:@"TranslationService"];
    [preferences registerObject:&searchEngine default:@"https://encrypted.google.com/search?q=%s" forKey:@"SearchEngine"];

    %init(Selector);
}
