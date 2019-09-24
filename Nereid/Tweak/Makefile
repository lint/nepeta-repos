ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nereid
$(TWEAK_NAME)_FILES = Tweak.xm UIImage+BlurAndDarken.m
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore WebKit
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += MediaRemote
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei
$(TWEAK_NAME)_LIBRARIES = colorpicker nepeta

include $(THEOS_MAKE_PATH)/tweak.mk