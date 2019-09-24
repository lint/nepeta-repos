

typedef struct SBIconCoordinate {
	long long row;
	long long col;
} SBIconCoordinate;

@interface SBIconListView : UIView 

-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 ;
-(CGPoint)originForIconAtIndex:(unsigned long long)arg1 ;
-(CGSize)defaultIconSize;
-(double)horizontalIconPadding;
-(CGSize)defaultIconSize;
-(double)verticalIconPadding;
-(double)sideIconInset;
-(unsigned long long)iconRowsForSpacingCalculation;
-(double)topIconInset;
-(double)bottomIconInset;

@end

@interface SBDockIconListView : SBIconListView 

-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 ;
+(double)defaultHeight;

@end

%hook SBDockIconListView

+(unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1 {
    return 4;
}

+(unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1 {
    return 2;
}

+(unsigned long long)maxVisibleIconRowsInterfaceOrientation:(long long)arg1 {
    return 2;
}

+(double)defaultHeight {
    return %orig * 1.75;
}

-(double)_additionalHorizontalInsetToCenterIcons {
    return 0;
}

-(double)_additionalVerticalInsetToCenterIcons {
    return 0;
}

-(UIEdgeInsets)layoutInsets {
    return UIEdgeInsetsMake(0,0,0,0);
}

-(unsigned long long)rowAtPoint:(CGPoint)arg1 {
    CGFloat div = arg1.y/[%c(SBDockIconListView) defaultHeight];
    return (div > 0.5) ? 1 : 0;
}

-(CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 {
    CGSize size = [self defaultIconSize];
    CGFloat top = [%c(SBDockIconListView) defaultHeight]/2 - size.height;

    CGFloat x = (size.width + [self horizontalIconPadding]) * (arg1.col - 1) + [self sideIconInset];
    CGFloat y = (size.height) * (arg1.row - 1) + top * 2;

    return CGPointMake(x, y);
}

%end