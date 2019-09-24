ARCHS = armv7 arm64 arm64e
TARGET = iphone::9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BegoneCIA
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk