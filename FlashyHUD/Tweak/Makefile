ARCHS = armv7 arm64 arm64e
TARGET = iphone:clang:11.2:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlashyHUD
$(TWEAK_NAME)_FILES = Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore WebKit
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei
$(TWEAK_NAME)_LIBRARIES += colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk