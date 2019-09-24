ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libexo
$(LIBRARY_NAME)_OBJC_FILES = EXOWebView.m
$(LIBRARY_NAME)_CFLAGS = -I./
$(LIBRARY_NAME)_FRAMEWORKS += WebKit
$(LIBRARY_NAME)_USE_MODULES = 0
$(LIBRARY_NAME)_PRIVATE_FRAMEWORKS += MediaRemote

ADDITIONAL_CFLAGS = -Ipublic -Ioverlayheaders -I. -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/Exo
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/Exo $(FW_RSYNC_EXCLUDES)$(ECHO_END)
