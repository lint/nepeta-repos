//
//  Interfaces.h
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#pragma mark Imports

#import "FLEXManager.h"

@interface UIWindow(Flexxx)

@property (nonatomic, retain) UILongPressGestureRecognizer *flexxxGestureRecognizer;
- (void)flexxxEnable;
- (void)flexxxShow;

@end

@interface SBWindow : UIWindow

@end