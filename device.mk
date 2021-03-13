# Shipping level
PRODUCT_SHIPPING_API_LEVEL := 30

# Dynamic partitions setup
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# AAPT
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# File systems table
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.default

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.0-impl-mock

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.sweet.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/init.sweet.rc

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.sweet

# VINTF
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/vintf/android.hardware.lights-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/android.hardware.lights-qti.xml

# NFC
PRODUCT_PACKAGES += \
    NfcNci \
    Tag \
    SecureElement \
    com.android.nfc_extras

# Device Settings
PRODUCT_PACKAGES += \
    DeviceSettings

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

include vendor/xiaomi/sweet/sweet-vendor.mk
