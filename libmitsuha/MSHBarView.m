#import "public/MSHBarView.h"

@implementation MSHBarView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.barCornerRadius = 13;
        self.barSpacing = 5;
    }

    return self;
}

-(void)initializeWaveLayers{
    [self resetWaveLayers];
    [self configureDisplayLink];
}

-(void)resetWaveLayers{
    self.layer.sublayers = nil;

    CGFloat width = ((self.frame.size.width - self.barSpacing)/(CGFloat)self.numberOfPoints);
    CGFloat barWidth = width - self.barSpacing;
    if (width <= 0) width = 1;
    if (barWidth <= 0) barWidth = 1;

    for (int i = 0; i < self.numberOfPoints; i++) {
        CALayer *layer = [[CALayer alloc] init];
        layer.cornerRadius = self.barCornerRadius;
        layer.frame = CGRectMake(i*width + self.barSpacing, 0, barWidth, self.frame.size.height);
        if (self.waveColor) {
            layer.backgroundColor = self.waveColor.CGColor;
        }
        [self.layer addSublayer:layer];
    }

    cachedNumberOfPoints = self.numberOfPoints;
}

-(void)updateWaveColor:(UIColor *)waveColor subwaveColor:(UIColor *)subwaveColor{
    self.waveColor = waveColor;
    for (CALayer *layer in [self.layer sublayers]) {
        layer.backgroundColor = waveColor.CGColor;
    }
}

- (void)redraw{
    [super redraw];
    
    if (cachedNumberOfPoints != self.numberOfPoints) {
        [self resetWaveLayers];
    }

    int i = 0;
    CGFloat width = ((self.frame.size.width - self.barSpacing)/(CGFloat)self.numberOfPoints);
    CGFloat barWidth = width - self.barSpacing;
    if (width <= 0) width = 1;
    if (barWidth <= 0) barWidth = 1;

    for (CALayer *layer in [self.layer sublayers]) {
        if (!layer) continue;
        if (isnan(self.points[i].y)) self.points[i].y = 0;
        CGFloat barHeight = self.frame.size.height-self.points[i].y;
        if (barHeight <= 0) barHeight = 1;
        
        layer.frame = CGRectMake(i*width + self.barSpacing, self.points[i].y, barWidth, barHeight);
        i++;
    }
}

@end