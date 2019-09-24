ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libmitsuha
$(LIBRARY_NAME)_OBJC_FILES = $(wildcard *.m)
$(LIBRARY_NAME)_CFLAGS = -I./
$(LIBRARY_NAME)_FRAMEWORKS += QuartzCore
$(LIBRARY_NAME)_USE_MODULES = 0

ADDITIONAL_CFLAGS = -Ipublic -Ioverlayheaders -I. -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/Mitsuha
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/Mitsuha $(FW_RSYNC_EXCLUDES)$(ECHO_END)
