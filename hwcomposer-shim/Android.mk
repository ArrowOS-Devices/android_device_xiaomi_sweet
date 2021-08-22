LOCAL_PATH := $(call my-dir)
LIBSDMCORE := $(TARGET_OUT_VENDOR)/lib64/libsdmcore.so

include $(CLEAR_VARS)
LOCAL_MODULE := libsdmcore-patch
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_REQUIRED_MODULES := libsdmcore

LOCAL_POST_INSTALL_CMD := \
    sed -i s/_ZN3sdm14DisplayBuiltIn14SetRefreshRateEjb/_ZN3sdm14DisplayBuiltIn14SetRefreshOrigEjb/g $(LIBSDMCORE)

include $(BUILD_PREBUILT)
