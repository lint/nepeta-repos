ARCHS = arm64
TARGET = iphone:clang:11.2

include $(THEOS)/makefiles/common.mk

ADDITIONAL_OBJCFLAGS = -fobjc-arc

TWEAK_NAME = StackXI
$(TWEAK_NAME)_FILES = Tweak.xm ../SXICommon.m
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/tweak.mk
