ARCHS = armv7 armv7s arm64 arm64e
TARGET = iphone:clang:11.2:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Swipeshot
$(TWEAK_NAME)_FILES = Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk