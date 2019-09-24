
ifeq ($(SIMULATOR),1)
ARCHS = x86_64
TARGET = simulator:clang:12.1:12.1
else
ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotToday12
$(TWEAK_NAME)_FILES = Tweak.xm

ifeq ($(SIMULATOR),1)
ADDITIONAL_OBJCFLAGS = -fobjc-arc -DSIMULATOR=1
else
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
ADDITIONAL_OBJCFLAGS = -fobjc-arc
endif

include $(THEOS_MAKE_PATH)/tweak.mk

after-all::
ifeq ($(SIMULATOR),1)
	rm /opt/simject/$(TWEAK_NAME).dylib
	cp .theos/obj/iphone_simulator/debug/x86_64/$(TWEAK_NAME).dylib /opt/simject/
	~/simject/bin/respring_simulator
endif