ARCHS = arm64 armv7 arm64e
TARGET = iphone:clang::6.0

include $(THEOS)/makefiles/common.mk

ADDITIONAL_OBJCFLAGS = -fobjc-arc

TWEAK_NAME = LaunchtronAction
$(TWEAK_NAME)_FILES = Action.xm
$(TWEAK_NAME)_FRAMEWORKS += UIKit QuartzCore
$(TWEAK_NAME)_LIBRARIES += activator
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk