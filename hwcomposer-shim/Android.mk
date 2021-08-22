LOCAL_PATH := $(call my-dir)
LIBSDMCORE := $(TARGET_OUT_VENDOR)/lib64/libsdmcore.so
HWCOMPOSER := $(TARGET_OUT_VENDOR)/lib64/hw/hwcomposer.$(TARGET_BOARD_PLATFORM).so

include $(CLEAR_VARS)
LOCAL_MODULE := libsdmcore-patch
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_REQUIRED_MODULES := hwcomposer.$(TARGET_BOARD_PLATFORM) libsdmcore

LOCAL_POST_INSTALL_CMD := \
    sed -i s/_ZN3sdm14DisplayBuiltIn14SetRefreshRateEjb/_ZN3sdm14DisplayBuiltIn14SetRefreshOrigEjb/g $(LIBSDMCORE); \
    sed -i s/libdisplaydebug/libsdmcore-shim/g $(HWCOMPOSER)

include $(BUILD_PREBUILT)
