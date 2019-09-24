BOOL isDark(UIColor *backgroundColor) {
    size_t count = CGColorGetNumberOfComponents(backgroundColor.CGColor);
    const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);

    CGFloat darknessScore = 0;
    if (count == 2) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
    } else if (count == 4) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
    }

    NSLog(@"[MitsuhaXI] Darkness score: %f", darknessScore);

    if (darknessScore >= 125) {
        return NO;
    }

    return YES;
}