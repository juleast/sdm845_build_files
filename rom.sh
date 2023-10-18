#!/bin/bash

# Clone ROM trees for Android T
clone_android_t() {
    rm -rf device/lge/${device}
    rm -rf device/lge/sdm845-common
    rm -rf kernel/lge/sdm845
    rm -rf vendor/lge
    rm -rf hardware/lg
    rm -rf device/lge

    git clone https://github.com/EmanuelCN/android_device_lge_common -b T device/lge/common
    git clone https://github.com/EmanuelCN/android_device_lge_hardware -b R hardware/lge
    git clone https://github.com/EmanuelCN/android_device_lge_${device} -b T device/lge/${device}
    git clone https://github.com/EmanuelCN/proprietary_vendor_lge -b T vendor/lge
    git clone https://github.com/EmanuelCN/android_device_lge_sdm845-common -b T device/lge/sdm845-common
    git clone https://github.com/EmanuelCN/android_kernel_lge_sdm845 -b T kernel/lge/sdm845

    git clone --depth=1 https://github.com/kdrag0n/proton-clang.git prebuilts/clang/host/linux-x86/clang-proton

    rm -rf hardware/qcom-caf/sdm845/audio
    rm -rf hardware/qcom-caf/sdm845/display
    rm -rf hardware/qcom-caf/sdm845/media
    git clone https://github.com/EmanuelCN/hardware_qcom-caf_sdm845_display -b twelve hardware/qcom-caf/sdm845/display
    git clone https://github.com/LineageOS/android_hardware_qcom_media/ -b lineage-19.1-caf-sdm845 hardware/qcom-caf/sdm845/media
    git clone https://github.com/LineageOS/android_hardware_qcom_audio/ -b lineage-19.1-caf-sdm845 hardware/qcom-caf/sdm845/audio

    modify_rom_prefix
}

# Clone ROM trees for Android R
clone_android_r() {
    rm -rf device/lge/${device}
    rm -rf device/lge/sdm845-common
    rm -rf kernel/lge/sdm845
    rm -rf vendor/lge
    rm -rf hardware/lge
    rm -rf device/lge

    git clone https://github.com/EmanuelCN/android_device_lge_common -b R device/lge/common
    git clone https://github.com/EmanuelCN/android_device_lge_hardware -b R hardware/lge
    git clone https://github.com/EmanuelCN/android_device_lge_${device} -b R device/lge/${device}
    git clone https://github.com/EmanuelCN/proprietary_vendor_lge -b T vendor/lge
    git clone https://github.com/EmanuelCN/android_device_lge_sdm845-common -b R device/lge/sdm845-common
    git clone https://github.com/EmanuelCN/android_kernel_lge_sdm845 -b T kernel/lge/sdm845

    git clone --depth=1 https://github.com/kdrag0n/proton-clang.git prebuilts/clang/host/linux-x86/clang-proton

    rm -rf hardware/qcom-caf/sdm845/audio
    rm -rf hardware/qcom-caf/sdm845/display
    rm -rf hardware/qcom-caf/sdm845/media
    git clone https://github.com/EmanuelCN/hardware_qcom-caf_sdm845_display -b eleven hardware/qcom-caf/sdm845/display
    git clone https://github.com/LineageOS/android_hardware_qcom_media/ -b lineage-18.1-caf-sdm845 hardware/qcom-caf/sdm845/media
    git clone https://github.com/LineageOS/android_hardware_qcom_audio/ -b lineage-18.1-caf-sdm845 hardware/qcom-caf/sdm845/audio

    modify_rom_prefix
}

# Modify ROM prefix
modify_rom_prefix() {
    echo "Rom Bringup"
    read -p "New rom prefix: " rom

    echo "Performing renaming..."
    cd device/lge/${device}
    find . -not -path "*/.*" -name "*.mk" -type f -exec sed -i "s/aosp/${rom}/g" {} +
    mv aosp_${device}.mk ${rom}_${device}.mk
    echo "Successfully renamed prefix to ${rom}"
}

# Main script

echo "Select the device:"
echo "1. judyln"
echo "2. judypn"
echo "3. judyp"

read -p "Enter your choice (1-3): " device_choice

echo "Select the Android version:"
echo "1. Android T"
echo "2. Android R"

read -p "Enter your choice (1-2): " version_choice

case ${device_choice} in
    1)
        device="judyln"
        ;;
    2)
        device="judypn"
        ;;
    3)
        device="judyp"
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

case ${version_choice} in
    1)
        android_version="T"
        clone_android_t
        ;;
    2)
        android_version="R"
        clone_android_r
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo "ROM trees cloned for device ${device} with Android ${android_version}."
