ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cuboid
Cuboid_FILES = Tweak.xm $(wildcard CBD*.m)
Cuboid_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"