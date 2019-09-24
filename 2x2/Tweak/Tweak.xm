%hook SBFolderIconListView

+ (unsigned long long)maxVisibleIconRowsInterfaceOrientation:(long long)arg1 {
    return 2;
}

+ (unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1 {
    return 2;
}

- (CGFloat)topIconInset {
    CGFloat orig = %orig;
    return orig*1.5;
}

- (CGFloat)sideIconInset {
    CGFloat orig = %orig;
    return orig*1.5;
}

- (CGFloat)verticalIconPadding {
    CGFloat orig = %orig;
    return orig/1.5;
}

%end

%hook SBFolderIconImageView

- (CGRect)frameForMiniIconAtIndexPath:(NSIndexPath *)arg1 {
    CGRect orig = %orig;

    CGFloat y = orig.origin.y;
    if (arg1.row > 1) {
        y *= 1.36;
    } else {
        y /= 1.06;
    }

    return CGRectMake(orig.origin.x, y, orig.size.width, orig.size.height * 1.6);
}


%end

%hook SBIconGridImage

+ (CGSize)cellSize {
    CGSize orig = %orig;
    return CGSizeMake(orig.width * 1.54, orig.height);
}


+ (unsigned long long)numberOfColumns {
    return 2;
}

+ (unsigned long long)numberOfRowsForNumberOfCells:(unsigned long long)count {
    if (count >= 3) return 2;
    return 1;
}

+ (CGSize)cellSpacing {
    CGSize orig = %orig;
    return CGSizeMake(orig.width * 1.54, orig.height);
}


%end