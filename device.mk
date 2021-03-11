# Shipping level
PRODUCT_SHIPPING_API_LEVEL := 30

# Dynamic partitions setup
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# AAPT
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# File systems table
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.default
