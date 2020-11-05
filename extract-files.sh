#!/bin/bash
#
# Copyright (C) 2018-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export DEVICE=rova
export DEVICE_COMMON=msm8917-common
export VENDOR=xiaomi

export DEVICE_BRINGUP_YEAR=2017

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"

# Hax for cam configs
CAMERA2_SENSOR_MODULES="$ANDROID_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary/vendor/lib/libmmcamera2_sensor_modules.so

sed -i "s|/system/etc/camera/|/vendor/etc/camera/|g" "$CAMERA2_SENSOR_MODULES"

DEVICE_BLOB_ROOT="$ANDROID_ROOT"/vendor/"${VENDOR}"/"${DEVICE}"/proprietary

# Camera data
for CAMERA_LIB in libmmcamera2_cpp_module.so libmmcamera2_dcrf.so libmmcamera2_iface_modules.so libmmcamera2_imglib_modules.so libmmcamera2_mct.so libmmcamera2_pproc_modules.so libmmcamera2_q3a_core.so libmmcamera2_sensor_modules.so libmmcamera2_stats_algorithm.so libmmcamera2_stats_modules.so libmmcamera_dbg.so libmmcamera_imglib.so libmmcamera_interface.so libmmcamera_pdaf.so libmmcamera_pdafcamif.so libmmcamera_tintless_algo.so libmmcamera_tintless_bg_pca_algo.so libmmcamera_tuning.so; do
    sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "${DEVICE_BLOB_ROOT}"/vendor/lib/${CAMERA_LIB}
done

for CAMERA_LIB64 in libmmcamera2_q3a_core.so libmmcamera2_stats_algorithm.so libmmcamera_dbg.so libmmcamera_tintless_algo.so libmmcamera_tintless_bg_pca_algo.so; do
    sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "${DEVICE_BLOB_ROOT}"/vendor/lib64/${CAMERA_LIB64}
done

# Camera socket
sed -i "s|/data/misc/camera/cam_socket|/data/vendor/qcam/cam_socket|g" "$DEVICE_BLOB_ROOT"/vendor/bin/mm-qcamera-daemon

# VNDK
for CAMERA_LIB in libmmsw_detail_enhancement.so libmmcamera2_stats_modules.so libmmsw_platform.so libmmcamera_ppeiscore.so; do
    sed -i "s|libgui.so|libwui.so|g" "${DEVICE_BLOB_ROOT}"/vendor/lib/${CAMERA_LIB}
done

"${PATCHELF}" --replace-needed "libandroid.so" "libcamera_shim.so" "${DEVICE_BLOB_ROOT}"/vendor/lib/libmmcamera2_stats_modules.so
"${PATCHELF}" --replace-needed "libcamera_shim.so" "libshim_camera.so" "${DEVICE_BLOB_ROOT}"/vendor/lib/libmmcamera2_stats_modules.so
