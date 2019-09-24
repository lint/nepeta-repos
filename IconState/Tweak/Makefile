ARCHS = armv7 arm64 arm64e
TARGET = iphone:clang:11.2:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IconState
$(TWEAK_NAME)_FILES = Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk