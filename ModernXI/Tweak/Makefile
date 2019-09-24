ARCHS = arm64
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ModernXI
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_LIBRARIES += applist
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/tweak.mk