#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/sweet

# Kernel
TARGET_KERNEL_CONFIG := sweet_user_defconfig

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom

# Inherit from proprietary files
include vendor/xiaomi/sweet/BoardConfigVendor.mk
