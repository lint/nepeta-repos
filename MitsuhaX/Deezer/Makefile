ARCHS = arm64
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MitsuhaXIDeezer
$(TWEAK_NAME)_FILES = Tweak.xm ../MSHJelloView.mm
$(TWEAK_NAME)_LIBRARIES += colorpicker
$(TWEAK_NAME)_FRAMEWORKS += QuartzCore
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk