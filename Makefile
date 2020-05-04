ARCHS = arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppGroupChecker

AppGroupChecker_FILES = Tweak.x
AppGroupChecker_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += appgroupcheckerpreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
