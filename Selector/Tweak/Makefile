ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Selector
$(TWEAK_NAME)_FILES = SLCWindow.m Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore WebKit
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk