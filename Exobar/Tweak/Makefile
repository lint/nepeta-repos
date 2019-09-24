ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Exobar
$(TWEAK_NAME)_FILES = Tweak.xm ../EXBTheme.m
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore WebKit
$(TWEAK_NAME)_LIBRARIES = exo
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk