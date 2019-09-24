#import "public/MSHLineView.h"

@implementation MSHLineView

-(void)initializeWaveLayers{
    self.waveLayer = [MSHJelloLayer layer];
    
    self.waveLayer.frame = self.bounds;
    
    [self.layer addSublayer:self.waveLayer];
    
    self.waveLayer.zPosition = 0;
    self.waveLayer.lineWidth = 5;
    self.waveLayer.fillColor = [UIColor clearColor].CGColor;

    [self configureDisplayLink];
    [self resetWaveLayers];

    self.waveLayer.shouldAnimate = true;
}

-(void)setLineThickness:(CGFloat)thickness {
    _lineThickness = thickness;
    self.waveLayer.lineWidth = thickness;
}

-(void)resetWaveLayers{
    if (!self.waveLayer) {
        [self initializeWaveLayers];
    }
    
    CGPathRef path = [self createPathWithPoints:self.points
                                     pointCount:0
                                         inRect:self.bounds];
    
    NSLog(@"[libmitsuha]: Resetting Wave Layers...");
    
    self.waveLayer.path = path;
}

-(void)updateWaveColor:(UIColor *)waveColor subwaveColor:(UIColor *)subwaveColor{
    self.waveColor = waveColor;
    self.subwaveColor = subwaveColor;
    self.waveLayer.strokeColor = waveColor.CGColor;
}

- (void)redraw{
    [super redraw];
    
    CGPathRef path = [self createPathWithPoints:self.points
                                     pointCount:self.numberOfPoints
                                         inRect:self.bounds];
    self.waveLayer.path = path;
}

- (void)setSampleData:(float *)data length:(int)length{
    [super setSampleData:data length:length];
    
    self.points[self.numberOfPoints - 1].x = self.bounds.size.width;
    self.points[0].y = self.points[self.numberOfPoints - 1].y = self.waveOffset;
}

- (CGPathRef)createPathWithPoints:(CGPoint *)points
                       pointCount:(NSUInteger)pointCount
                           inRect:(CGRect)rect {
    UIBezierPath *path;
    
    if (pointCount > 0){
        path = [UIBezierPath bezierPath];
        
        [path moveToPoint:self.points[0]];
        
        for (int i = 0; i<self.numberOfPoints; i++) {
            [path addLineToPoint:self.points[i]];
        }
    }else{
        float pixelFixer = self.bounds.size.width/self.numberOfPoints;
        
        if(cachedNumberOfPoints != self.numberOfPoints){
            self.points = (CGPoint *)malloc(sizeof(CGPoint) * self.numberOfPoints);
            cachedNumberOfPoints = self.numberOfPoints;
            
            for (int i = 0; i < self.numberOfPoints; i++){
                self.points[i].x = i*pixelFixer;
                self.points[i].y = self.waveOffset; //self.bounds.size.height/2;
            }
            
            self.points[self.numberOfPoints - 1].x = self.bounds.size.width;
            self.points[0].y = self.points[self.numberOfPoints - 1].y = self.waveOffset; //self.bounds.size.height/2;
        }
        
        return [self createPathWithPoints:self.points
                               pointCount:self.numberOfPoints
                                   inRect:self.bounds];
    }
    
    CGPathRef convertedPath = path.CGPath;
    
    return CGPathCreateCopy(convertedPath);
}

@end