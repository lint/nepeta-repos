//
//  MSHJelloView.h
//  Mitsuha
//
//  Created by c0ldra1n on 2/5/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSHJelloViewConfig : NSObject

@property BOOL enabled;
@property (nonatomic, assign) NSString* application;

@property BOOL enableDynamicGain;
@property BOOL enableDynamicColor;
@property BOOL enableNewColor;
@property BOOL enableAutoUIColor;
@property BOOL enableFFT;
@property BOOL enableCoverArtBugFix;
@property BOOL enableBatterySaver;
@property BOOL enableAutoHide;
@property double gain;
@property double limiter;

@property (nonatomic, retain) UIColor *waveColor;
@property (nonatomic, retain) UIColor *subwaveColor;

@property NSUInteger numberOfPoints;
@property CGFloat fps;

@property CGFloat waveOffset;
@property CGFloat sensitivity;
@property CGFloat dynamicColorAlpha;

@property BOOL ignoreColorFlow;

@property BOOL enableCircleArtwork;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

+(MSHJelloViewConfig *)loadConfigForApplication:(NSString *)name;

@end

@interface MSHJelloLayer : CAShapeLayer

@property BOOL shouldAnimate;

@end

@interface MSHJelloView : UIView{
    NSUInteger cachedLength;
    int connfd;
    float *empty;
    long long silentSince;
    bool jelloHidden;
}

@property (nonatomic, strong) MSHJelloViewConfig *config;
@property (nonatomic, assign) BOOL shouldUpdate;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint *points;

@property (nonatomic, strong) MSHJelloLayer *waveLayer;
@property (nonatomic, strong) MSHJelloLayer *subwaveLayer;

@property (nonatomic, strong) UIColor *calculatedColor;

-(void)updateWaveColor:(UIColor *)waveColor subwaveColor:(UIColor *)subwaveColor;
-(void)dynamicColor:(UIImage *)image;

-(void)reloadConfig;
-(void)msdConnect;
-(void)msdDisconnect;

-(void)initializeWaveLayers;
-(void)resetWaveLayers;
-(void)redraw;

-(CGPathRef)createPathWithPoints:(CGPoint *)points pointCount:(NSUInteger)pointCount inRect:(CGRect)rect;

-(void)requestUpdate;
-(void)updateBuffer:(float *)bufferData withLength:(int)length;

-(void)setSampleData:(float *)data length:(int)length;

-(instancetype)initWithFrame:(CGRect)frame andConfig:(MSHJelloViewConfig *)config;

@end
