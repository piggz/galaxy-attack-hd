LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := scoreloopcore
LOCAL_SRC_FILES := $(abspath $(LOCAL_PATH))/libraries/$(TARGET_ARCH_ABI)/libscoreloopcore.so
LOCAL_EXPORT_C_INCLUDES += $(abspath $(LOCAL_PATH))/include
include $(PREBUILT_SHARED_LIBRARY)