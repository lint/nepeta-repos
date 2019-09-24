#import "Tweak.h"

#define MAX_EXTRAS 10

%group BrokenHUD

%hook SBMediaController

/*- (void)_commitVolumeChange:(id)arg1;
- (void)decreaseVolume;
- (void)increaseVolume;
- (void)_changeVolumeBy:(float)arg1;*/
- (void)setVolume:(float)arg1 {
    NSLog(@"[BrokenHUD] vol = %f", arg1);
    %orig;
}

%end

%hook SBVolumeHUDView

%property (assign,nonatomic) int extras;
%property (assign,nonatomic) float origWidth;
%property (assign,nonatomic) int pretendVol;
%property (assign,nonatomic) int lastVol;
%property (nonatomic,retain) NSMutableOrderedSet *extraLayers;

-(void)_updateBlockView:(id)arg1 value:(float)arg2 blockSize:(CGSize)arg3 point:(CGPoint)arg4 {
    //NSLog(@"[BrokenHUD] value = %f", arg2);
    //NSLog(@"[BrokenHUD] bsW = %f, bsH = %f, pX = %f, pY = %f", arg3.width, arg3.height, arg4.x, arg4.y);
    %orig;
    /*default	19:56:46.851288 +0100	SpringBoard	[BrokenHUD] bsW = 7.000000, bsH = 5.000000, pX = 105.000000, pY = 1.000000
default	19:56:46.851402 +0100	SpringBoard	[BrokenHUD] value = 0.875000
default	19:56:46.851524 +0100	SpringBoard	[BrokenHUD] bsW = 7.000000, bsH = 5.000000, pX = 113.000000, pY = 1.000000
default	19:56:46.851620 +0100	SpringBoard	[BrokenHUD] value = 0.937500
default	19:56:46.851724 +0100	SpringBoard	[BrokenHUD] bsW = 7.000000, bsH = 5.000000, pX = 121.000000, pY = 1.000000
default	19:56:46.851817 +0100	SpringBoard	[BrokenHUD] value = 1.000000
default	19:56:46.851929 +0100	SpringBoard	[BrokenHUD] bsW = 7.000000, bsH = 5.000000, pX = 129.000000, pY = 1.000000
*/
}

-(CGColor*)_blockColorForValue:(float)arg1 {
    NSLog(@"[BrokenHUD] bcfv = %f", arg1);
    return %orig;
}

+(long long)numberOfProgressIndicatorSteps {
    long long orig = %orig;
    return orig + 10;
}


-(id)init {
    NSLog(@"[BrokenHUD] Init");
    id orig = %orig;
    self.extraLayers = [NSMutableOrderedSet orderedSetWithCapacity:MAX_EXTRAS];
    for (int i = 0; i < MAX_EXTRAS; i++) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(129 + i*8, 1, 7, 5);
        layer.backgroundColor = [[UIColor whiteColor] CGColor];
        [self.extraLayers addObject:layer];
    }
    self.pretendVol = 0;
    self.extras = -1;
    return orig;
}

-(void)_updateBackdropMask {
    %orig;
    UIImageView* backdropMaskImageView = [self valueForKey:@"_backdropMaskImageView"];
    UIView* backdropView = [self valueForKey:@"_backdropView"];
    backdropMaskImageView.layer.cornerRadius = 10;
    backdropMaskImageView.layer.masksToBounds = true;
    backdropView.layer.cornerRadius = 10;
    backdropView.layer.masksToBounds = true;
}

-(void)_updateBlockView {
    %orig;
    UIView *blockView = [self valueForKey:@"_blockView"];
    self.clipsToBounds = FALSE;
    UIView *superview = (UIView*) [self superview];
    superview.clipsToBounds = FALSE;
    if (self.pretendVol == 0) {
        blockView.backgroundColor = [UIColor clearColor];
    } else {
        blockView.backgroundColor = [UIColor blackColor];
    }
    int posExtras = self.extras;
    if (posExtras < 0) {
        posExtras = 0;
    }
    if (!self.origWidth) {
        self.origWidth = blockView.frame.size.width;
    }
    blockView.frame = CGRectMake(blockView.frame.origin.x, blockView.frame.origin.y, self.origWidth + posExtras*8, blockView.frame.size.height);
    for (int i = 0; i < [self.extraLayers count]; i++) {
        [self.extraLayers[i] removeFromSuperlayer];
    }
    for (int i = 0; i < self.extras; i++) {
        [blockView.layer addSublayer:self.extraLayers[i]];
    }
}

-(void)setProgress:(float)arg1 {
    NSLog(@"[BrokenHUD] vol = %f", arg1);
    if (self.pretendVol == 0) {
        self.pretendVol = arg1*16;
        self.lastVol = arg1*16;
    }

    if (arg1*16 < self.lastVol || arg1 == 0.0) {
        self.pretendVol--;
    }

    if (arg1*16 > self.lastVol || arg1 == 1.0) {
        self.pretendVol++;
    }

    if (self.pretendVol > 16 + MAX_EXTRAS) {
        self.pretendVol = 16 + MAX_EXTRAS;
    }

    if (self.pretendVol < 0) {
        self.pretendVol = 0;
    }

    self.lastVol = arg1*16;
    
    if (self.pretendVol > 16) {
        arg1 = 1.0;
        self.extras = self.pretendVol - 16;
    } else {
        self.extras = -1;
        arg1 = ((float)self.pretendVol)/16.0;
    }

    %orig;
}

%end

%end

%ctor{
    %init(BrokenHUD);
}
