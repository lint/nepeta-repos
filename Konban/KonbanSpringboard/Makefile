ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KonbanSpringboard
$(TWEAK_NAME)_FILES = KonbanSpringboard.xm Konban.m
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk