#
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TARGET_KERNEL_VERSION := 4.9

# Inherit from common msm8917-common
-include device/xiaomi/msm8917-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/rova

# HIDL
ifeq ($(TARGET_KERNEL_VERSION),3.18)
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest-l2.xml
else ifeq ($(TARGET_KERNEL_VERSION),4.9)
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest-l3.xml
endif

# Asserts
TARGET_OTA_ASSERT_DEVICE := rolex,riva,rova

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_rova
TARGET_RECOVERY_DEVICE_MODULES := libinit_rova

# Kernel
TARGET_KERNEL_CONFIG := rova_defconfig
TARGET_KERNEL_SOURCE := kernel/xiaomi/msm8917

# Partitions
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10332634112 # 10332650496 - 16384
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912
TARGET_COPY_OUT_VENDOR := vendor

# Power
TARGET_TAP_TO_WAKE_NODE := "/proc/gesture/onoff"

# Security Patch Level
VENDOR_SECURITY_PATCH := 2020-05-05

# Sepolicy
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

# Treble
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_VNDK_VERSION := current
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true

# Inherit from the proprietary version
-include vendor/xiaomi/rova/BoardConfigVendor.mk
