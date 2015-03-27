SDKVERSION = 7.0
ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = MatchInMusic
MatchInMusic_FILES = Switch.x
MatchInMusic_PRIVATE_FRAMEWORKS = AppSupport
MatchInMusic_LIBRARIES = flipswitch
MatchInMusic_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
