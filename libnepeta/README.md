# libnepeta

Nepeta's color utilities (and more in the future).

Contains ported logic from @jathu's: [UIImageColors library for Swift](https://github.com/jathu/UIImageColors/blob/master/Sources/UIImageColors.swift) (MIT license).

## Usage

Contains 2 classes and one struct. NEPColor is mostly useless, so I'll skip this one.

### NEPColorUtils

#### +(BOOL)isDark:(UIColor *)color;

Returns true if the UIColor given is dark.

#### +(struct NEPPalette)averageColors:(UIImage *)img withAlpha:(double)alpha;

Returns a NEPPalette of 4 dominant colors in a given image with each color having a given alpha.

#### +(UIColor *)averageColor:(UIImage *)image withAlpha:(double)alpha;

Returns one dominant color from a given image with that color having a given alpha. (This is the old method in MitsuhaXI/Mitsuha Infinity).

#### +(UIColor *)averageColorNew:(UIImage *)img withAlpha:(double)alpha;

Returns one dominant color from a given image with that color having a given alpha. (This is the new method in MitsuhaXI/Mitsuha Infinity).

#### +(UIColor *)colorWithMinimumSaturation:(UIColor *)img withSaturation:(double)saturation;

Returns a new UIColor made from the given UIColor but with a saturation matching or being higher than the given saturation.

### NEPPalette

A struct containing 4 UIColors.

This is basically the UIImageColors object from [this library](https://github.com/jathu/UIImageColors).

```
struct NEPPalette {
    UIColor *background;
    UIColor *primary;
    UIColor *secondary;
    UIColor *detail;
};
```

## Using it in your own projects

Install libnepeta from my repo ([https://repo.nepeta.me/](https://repo.nepeta.me/)) on your device and copy the following directories/files to your computer.

/usr/include/Nepeta -> $THEOS/include/Nepeta

/usr/lib/libnepeta.dylib -> $THEOS/lib/libnepeta.dylib

Then add libnepeta to your project:

Makefile: 

```
[PROJECT_NAME]_LIBRARIES += [your other libraries] nepeta
```

control file:

```
Depends: [other dependencies] me.nepeta.libnepeta
```