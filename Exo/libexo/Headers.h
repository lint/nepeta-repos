@interface LSApplicationWorkspace
- (bool)openApplicationWithBundleID:(id)arg1;
@end

@interface SpringBoard : UIApplication

-(void)launchApplicationWithIdentifier:(NSString *)bundle suspended:(BOOL)suspended;

@end