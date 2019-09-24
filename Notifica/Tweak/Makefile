ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Notifica
$(TWEAK_NAME)_FILES = Tweak.xm NTFConfig.m NTFManager.m
$(TWEAK_NAME)_FRAMEWORKS += QuartzCore MediaPlayer
$(TWEAK_NAME)_LIBRARIES += nepeta colorpicker
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += MediaRemote
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk