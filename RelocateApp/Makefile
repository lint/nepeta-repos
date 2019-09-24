ARCHS = armv7 armv7s arm64 arm64e
TARGET = iphone:clang:11.2:9.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Relocate
$(APPLICATION_NAME)_FILES = main.m RLCAppDelegate.m
$(APPLICATION_NAME)_FRAMEWORKS = UIKit CoreGraphics
$(APPLICATION_NAME)_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"Relocate\"" || true
