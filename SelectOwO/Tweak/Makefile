ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SelectOwO
$(TWEAK_NAME)_FILES = Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore WebKit

include $(THEOS_MAKE_PATH)/tweak.mk