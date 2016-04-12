# Copyright (C) 2013 The CyanogenMod Project
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

# inherit from the common fusion3 definitions
include device/sony/fusion3-common/BoardConfigCommon.mk

# inherit from the proprietary version
-include vendor/sony/dogo/BoardConfigVendor.mk

# Assert
TARGET_OTA_ASSERT_DEVICE := C5502,C5503,C5506,dogo

TARGET_SPECIFIC_HEADER_PATH += device/sony/dogo/include

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/sony/dogo/bluetooth

TARGET_KERNEL_CONFIG := fusion3_dogo_defconfig

# Healthd
BACKLIGHT_PATH := /sys/class/leds/lm3533-lcd-bl/brightness

# Partition information
BOARD_VOLD_MAX_PARTITIONS := 26

# TWRP flags
DEVICE_RESOLUTION := 720x1280
TW_EXCLUDE_DEFAULT_USB_INIT := true
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TW_HAS_NO_RECOVERY_PARTITION := true
TW_NO_REBOOT_BOOTLOADER := true
TW_FLASH_FROM_STORAGE := true
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
TW_DEFAULT_EXTERNAL_STORAGE := true
TW_INCLUDE_JB_CRYPTO := true
TW_INCLUDE_FUSE_EXFAT := true
TW_MAX_BRIGHTNESS := 255
TW_BRIGHTNESS_PATH := "/sys/class/leds/lm3533-lcd-bl/brightness"
TW_SECONDARY_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x01400000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x01400000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
BOARD_USERDATAIMAGE_PARTITION_SIZE := 4923387904

BOARD_HARDWARE_CLASS += device/sony/dogo/cmhw
