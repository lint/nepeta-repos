//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//


#import "Interfaces.h"

%hook SBWindow

- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
}

- (id)initWithFrame:(CGRect)frame {
    %orig;
    [self flexxxEnable];
    return self;
}

-(id)_initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 rootViewController:(id)arg4 scene:(id)arg5 {
    %orig;
    [self flexxxEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 {
    %orig;
    [self flexxxEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 debugName:(id)arg2 rootViewController:(id)arg3 {
    %orig;
    [self flexxxEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 layoutStrategy:(id)arg2 debugName:(id)arg3 scene:(id)arg4 {
    %orig;
    [self flexxxEnable];
    return self;
}

-(id)initWithScreen:(id)arg1 debugName:(id)arg2 {
    self = %orig;
    [self flexxxEnable];
    return self;
}

%end

%hook UIWindow

%property (nonatomic, retain) UILongPressGestureRecognizer *flexxxGestureRecognizer;

- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
}

%new
- (void)flexxxShow {
    [[FLEXManager sharedManager] showExplorer];
}

%new
- (void)flexxxEnable {
    if (self.flexxxGestureRecognizer) return;
    self.flexxxGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(flexxxShow)];
    self.flexxxGestureRecognizer.minimumPressDuration = .5;
    self.flexxxGestureRecognizer.numberOfTouchesRequired = 3;
    
    [self addGestureRecognizer:self.flexxxGestureRecognizer];
}

- (id)initWithFrame:(CGRect)frame {
    %orig;
    [self flexxxEnable];
    return self;
}

%end