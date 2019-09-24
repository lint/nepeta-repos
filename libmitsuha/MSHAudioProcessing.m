#import "public/MSHAudioProcessing.h"

@implementation MSHAudioProcessing

-(id)initWithBufferSize:(int)bufferSize {
    self = [super init];

    numberOfFrames = bufferSize;
    numberOfFramesOver2 = numberOfFrames / 2;
    fftNormFactor = -1.0/256.0;

    outReal = (float *)malloc(sizeof(float)*numberOfFramesOver2);
    outImaginary = (float *)malloc(sizeof(float)*numberOfFramesOver2);
    out = (float *)malloc(sizeof(float)*numberOfFramesOver2);
    output.realp = outReal;
    output.imagp = outImaginary;

    bufferLog2 = round(log2(numberOfFrames));
    fftSetup = vDSP_create_fftsetup(bufferLog2, kFFTRadix2);
    window = (float *)malloc(sizeof(float)*numberOfFrames);

    vDSP_hann_window(window, numberOfFrames, vDSP_HANN_NORM);

    return self;
}

-(void)process:(float *)data withLength:(int)length {
    if (!self.delegate) return;

    if (self.fft && length == numberOfFrames) {
        vDSP_vmul(data, 1, window, 1, data, 1, numberOfFrames);
        vDSP_ctoz((COMPLEX *)data, 2, &output, 1, numberOfFramesOver2);
        vDSP_fft_zrip(fftSetup, &output, 1, bufferLog2, FFT_FORWARD);
        vDSP_zvabs(&output, 1, out, 1, numberOfFramesOver2);
        vDSP_vsmul(out, 1, &fftNormFactor, out, 1, numberOfFramesOver2);
        [self.delegate setSampleData:out length:numberOfFramesOver2/8];
    } else {
        [self.delegate setSampleData:data length:length];
    }
}

@end