ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DouTool

DouTool_FILES = Tweak.xm DouToolSettingViewController.m
DouTool_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
