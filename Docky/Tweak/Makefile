ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Docky
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS += WebKit
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -O3

include $(THEOS_MAKE_PATH)/tweak.mk