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

# Inherit the fusion-common definitions
$(call inherit-product, device/sony/fusion3-common/fusion3.mk)

DEVICE_PACKAGE_OVERLAYS += device/sony/dogo/overlay

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml

# Recovery
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/recovery/root/etc/twrp.fstab:recovery/root/etc/twrp.fstab \
	$(LOCAL_PATH)/recovery/root/init.rc:recovery/root/init.rc \
	$(LOCAL_PATH)/recovery/root/init.original.rc:recovery/root/init.original.rc \
	$(LOCAL_PATH)/recovery/root/init.recovery.usb.rc:recovery/root/init.recovery.usb.rc \
	$(LOCAL_PATH)/recovery/root/sepolicy:recovery/root/sepolicy \
	$(LOCAL_PATH)/recovery/root/property_contexts:recovery/root/property_contexts \
	$(LOCAL_PATH)/recovery/root/sbin/xzdualrecovery.sh:recovery/root/sbin/xzdualrecovery.sh

# Boot
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/rootdir/sbin/mr:root/sbin/mr \
	$(LOCAL_PATH)/rootdir/sbin/tad_static:root/sbin/tad_static \
	$(LOCAL_PATH)/rootdir/sbin/wait4tad_static:root/sbin/wait4tad_static \
	$(LOCAL_PATH)/rootdir/sbin/wipedata:root/sbin/wipedata

# Screen
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# HW Settings
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/hw_config.sh:system/etc/hw_config.sh \
    $(LOCAL_PATH)/prebuilt/pre_hw_config.sh:system/etc/pre_hw_config.sh

# Sensors
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/etc/sensors.conf:system/etc/sensors.conf

# Device specific init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.device.rc:root/init.device.rc

# USB function switching
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.sony.usb.rc:root/init.sony.usb.rc

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/etc/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/rootdir/system/etc/mixer_paths.xml:system/etc/mixer_paths.xml

# Thermal monitor configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/etc/thermanager.xml:system/etc/thermanager.xml

# Touchpad
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/usr/idc/clearpad.idc:system/usr/idc/clearpad.idc

PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp,adb \
	persist.sys.isUsbOtgEnabled=true

ADDITIONAL_DEFAULT_PROPERTIES += \
	ro.adb.secure=0 \
	ro.secure=0 \
	ro.allow.mock.location=1 \
	persist.sys.root_access=1

# Hijack boot
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/system/bin/taimport:system/bin/taimport \
    $(LOCAL_PATH)/rootdir/system/hijack/hijack.sh:system/bin/hijack/hijack.sh

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xxhdpi-2048-dalvik-heap.mk)

# call hwui memory config
$(call inherit-product, frameworks/native/build/phone-xxhdpi-2048-hwui-memory.mk)

# Include non-opensource parts
$(call inherit-product, vendor/sony/dogo/dogo-vendor.mk)
