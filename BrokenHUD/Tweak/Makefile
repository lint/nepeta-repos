ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BrokenHUD
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk