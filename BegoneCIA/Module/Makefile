ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BegoneCIAModule
$(BUNDLE_NAME)_BUNDLE_EXTENSION = bundle
$(BUNDLE_NAME)_CFLAGS +=  -fobjc-arc -I$(THEOS_PROJECT_DIR)/headers
$(BUNDLE_NAME)_FILES = $(wildcard *.m)
$(BUNDLE_NAME)_LDFLAGS += $(THEOS_PROJECT_DIR)/Frameworks/ControlCenterUIKit.tbd
$(BUNDLE_NAME)_INSTALL_PATH = /Library/ControlCenter/Bundles/
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/bundle.mk
