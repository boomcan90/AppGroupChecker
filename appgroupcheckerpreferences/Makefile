include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AppGroupCheckerPreferences

AppGroupCheckerPreferences_FILES = PTPRootListController.m
AppGroupCheckerPreferences_INSTALL_PATH = /Library/PreferenceBundles
AppGroupCheckerPreferences_FRAMEWORKS = UIKit
AppGroupCheckerPreferences_PRIVATE_FRAMEWORKS = Preferences
AppGroupCheckerPreferences_EXTRA_FRAMEWORKS = Cephei
AppGroupCheckerPreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AppGroupCheckerPreferences.plist$(ECHO_END)
