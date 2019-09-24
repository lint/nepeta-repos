ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Copypasta
$(TWEAK_NAME)_FILES = CPAItem.m CPAView.m CPAObserver.m CPAManager.m Tweak.xm
ADDITIONAL_OBJCFLAGS = -fobjc-arc
$(TWEAK_NAME)_LIBRARIES += applist
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk