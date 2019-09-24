GO_EASY_ON_ME = 1

ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ZZZExoxen
$(TWEAK_NAME)_FILES = Tweak.xm 
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore WebKit
$(TWEAK_NAME)_LIBRARIES = exo

include $(THEOS_MAKE_PATH)/tweak.mk