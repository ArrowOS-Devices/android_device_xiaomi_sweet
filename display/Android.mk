LOCAL_PATH := $(call my-dir)

HWC := hwcomposer.$(TARGET_BOARD_PLATFORM)
LIBSDMCORE := $(TARGET_OUT_VENDOR)/lib64/libsdmcore.so
HWCOMPOSER := $(TARGET_OUT_VENDOR)/lib64/hw/$(HWC).so

ORIGINAL_SYMBOL := _ZN3sdm14DisplayBuiltIn14SetRefreshRateEjb
CUSTOM_SYMBOL := _ZN3sdm14DisplayBuiltIn14SetRefreshCustEjb

include $(CLEAR_VARS)
LOCAL_MODULE := libsdmcore-patch
LOCAL_PREBUILT_MODULE_FILE := /dev/null
LOCAL_MODULE_CLASS := ETC
LOCAL_VENDOR_MODULE := true
LOCAL_REQUIRED_MODULES := $(HWC) libsdmcore

LOCAL_POST_INSTALL_CMD := \
    cp $(PRODUCT_OUT)/symbols/vendor/lib64/libsdmcore.so $(LIBSDMCORE) && \
    cp $(PRODUCT_OUT)/symbols/vendor/lib64/hw/$(HWC).so $(HWCOMPOSER) && \
    sed -i s/$(ORIGINAL_SYMBOL)/$(CUSTOM_SYMBOL)/g $(LIBSDMCORE) && \
    sed -i s/libdisplaydebug/libsdmcore-shim/g $(HWCOMPOSER) && \
    rm $(TARGET_OUT_VENDOR)/etc/$(LOCAL_MODULE)

include $(BUILD_PREBUILT)
