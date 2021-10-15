#! /vendor/bin/sh

# Copyright (c) 2012-2013, 2016-2020, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

function configure_sku_parameters() {

#read feature id from nvram
reg_val=`cat /sys/devices/platform/soc/780130.qfprom/qfprom0/nvmem | od -An -t d4`
feature_id=$(((reg_val >> 20) & 0xFF))
log -t BOOT -p i "feature id '$feature_id'"
if [ $feature_id == 6 ]; then
	echo " SKU Configured : SA6145"
	echo 748800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo 748800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo 748800 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo 748800 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
	echo 748800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	echo 748800 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
	echo 1017600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
	echo 1017600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/min_freq
	echo 1017600000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/min_freq
	echo 1017600000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/max_freq
	echo 3 > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
	echo {class:ddr, res:capped, val: 1016} > /sys/kernel/debug/aop_send_message
	setprop vendor.sku_identified 1
	setprop vendor.sku_name "SA6145"
elif [ $feature_id == 5 ]; then
	echo "SKU Configured : SA6150"
	echo 748800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
	echo 998400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo 998400 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo 998400 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo 998400 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
	echo 998400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	echo 998400 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
	echo 1708800 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
	echo 1708800 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/min_freq
	echo 1363200000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/min_freq
	echo 1363200000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/max_freq
	echo 2 > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
	echo {class:ddr, res:capped, val: 1333} > /sys/kernel/debug/aop_send_message
	setprop vendor.sku_identified 1
	setprop vendor.sku_name "SA6150"
elif [ $feature_id == 4 ] || [ $feature_id == 3 ]; then
	echo "SKU Configured : SA6155"
	echo 748800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
	echo 1593600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
	echo 1900800 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
	echo 1900800 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/min_freq
	echo 1363200000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/min_freq
	echo 1363200000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/max_freq
	echo 0 > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
	echo {class:ddr, res:capped, val: 1555} > /sys/kernel/debug/aop_send_message
	setprop vendor.sku_identified 1
	setprop vendor.sku_name "SA6155"
else
	echo "SKU Configured : SA6155"
	echo 748800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo 748800 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
	echo 1017600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
	echo 1593600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	echo 1593600 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
	echo 1900800 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
	echo 1900800 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/min_freq
	echo 1363200000 > /sys/class/devfreq/soc\:qcom,cpu0-cpu-l3-lat/max_freq
	echo 940800000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/min_freq
	echo 1363200000 > /sys/class/devfreq/soc\:qcom,cpu6-cpu-l3-lat/max_freq
	echo 0 > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
	echo {class:ddr, res:capped, val: 1555} > /sys/kernel/debug/aop_send_message
        setprop vendor.sku_identified 1
	setprop vendor.sku_name "SA6155"
fi
}

function configure_zram_parameters() {
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    # Zram disk - 75% for Go devices.
    # For 512MB Go device, size = 384MB, set same for Non-Go.
    # For 1GB Go device, size = 768MB, set same for Non-Go.
    # For >=2GB Non-Go devices, size = 50% of RAM size. Limit the size to 4GB.
    # And enable lz4 zram compression for Go targets.

    let RamSizeGB="( $MemTotal / 1048576 ) + 1"
    let zRamSizeMB="( $RamSizeGB * 1024 ) / 2"
    diskSizeUnit=M

    # use MB avoid 32 bit overflow
    if [ $zRamSizeMB -gt 4096 ]; then
        let zRamSizeMB=4096
    fi

    if [ -f /sys/block/zram0/disksize ]; then
        if [ -f /sys/block/zram0/use_dedup ]; then
            echo 1 > /sys/block/zram0/use_dedup
        fi

        # ZRAM may use more memory than it saves if SLAB_STORE_USER
        # debug option is enabled.
        if [ -e /sys/kernel/slab/zs_handle ]; then
            echo 0 > /sys/kernel/slab/zs_handle/store_user
        fi
        if [ -e /sys/kernel/slab/zspage ]; then
            echo 0 > /sys/kernel/slab/zspage/store_user
        fi

        mkswap /dev/block/zram0
        swapon /dev/block/zram0 -p 32758
    fi
}

function configure_read_ahead_kb_values() {
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    dmpts=$(ls /sys/block/*/queue/read_ahead_kb | grep -e dm -e mmc)

    # Set 128 for <= 3GB &
    # set 512 for >= 4GB targets.
    if [ $MemTotal -le 3145728 ]; then
        echo 128 > /sys/block/mmcblk0/bdi/read_ahead_kb
        echo 128 > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
        for dm in $dmpts; do
            echo 128 > $dm
        done
    else
        echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
        echo 512 > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
        for dm in $dmpts; do
            echo 512 > $dm
        done
    fi
}

function disable_core_ctl() {
    if [ -f /sys/devices/system/cpu/cpu0/core_ctl/enable ]; then
        echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
    else
        echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/disable
    fi
}

function enable_swap() {
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    SWAP_ENABLE_THRESHOLD=1048576
    swap_enable=`getprop ro.vendor.qti.config.swap`

    # Enable swap initially only for 1 GB targets
    if [ "$MemTotal" -le "$SWAP_ENABLE_THRESHOLD" ] && [ "$swap_enable" == "true" ]; then
        # Static swiftness
        echo 1 > /proc/sys/vm/swap_ratio_enable
        echo 70 > /proc/sys/vm/swap_ratio

        # Swap disk - 200MB size
        if [ ! -f /data/vendor/swap/swapfile ]; then
            dd if=/dev/zero of=/data/vendor/swap/swapfile bs=1m count=200
        fi
        mkswap /data/vendor/swap/swapfile
        swapon /data/vendor/swap/swapfile -p 32758
    fi
}

function configure_memory_parameters() {
    # Set Memory parameters.
    #
    # Set per_process_reclaim tuning parameters
    # All targets will use vmpressure range 50-70,
    # All targets will use 512 pages swap size.
    #
    # Set Low memory killer minfree parameters
    # 32 bit Non-Go, all memory configurations will use 15K series
    # 32 bit Go, all memory configurations will use uLMK + Memcg
    # 64 bit will use Google default LMK series.
    #
    # Set ALMK parameters (usually above the highest minfree values)
    # vmpressure_file_min threshold is always set slightly higher
    # than LMK minfree's last bin value for all targets. It is calculated as
    # vmpressure_file_min = (last bin - second last bin ) + last bin
    #
    # Set allocstall_threshold to 0 for all targets.
    #

ProductName=`getprop ro.product.name`

arch_type=`uname -m`
MemTotalStr=`cat /proc/meminfo | grep MemTotal`
MemTotal=${MemTotalStr:16:8}

    # Read adj series and set adj threshold for PPR and ALMK.
    # This is required since adj values change from framework to framework.
    adj_series=`cat /sys/module/lowmemorykiller/parameters/adj`
    adj_1="${adj_series#*,}"
    set_almk_ppr_adj="${adj_1%%,*}"

    # PPR and ALMK should not act on HOME adj and below.
    # Normalized ADJ for HOME is 6. Hence multiply by 6
    # ADJ score represented as INT in LMK params, actual score can be in decimal
    # Hence add 6 considering a worst case of 0.9 conversion to INT (0.9*6).
    # For uLMK + Memcg, this will be set as 6 since adj is zero.
    set_almk_ppr_adj=$(((set_almk_ppr_adj * 6) + 6))
    echo $set_almk_ppr_adj > /sys/module/lowmemorykiller/parameters/adj_max_shift

    # Calculate vmpressure_file_min as below & set for 64 bit:
    # vmpressure_file_min = last_lmk_bin + (last_lmk_bin - last_but_one_lmk_bin)
    if [ "$arch_type" == "aarch64" ]; then
    minfree_series=`cat /sys/module/lowmemorykiller/parameters/minfree`
    minfree_1="${minfree_series#*,}" ; rem_minfree_1="${minfree_1%%,*}"
        minfree_2="${minfree_1#*,}" ; rem_minfree_2="${minfree_2%%,*}"
        minfree_3="${minfree_2#*,}" ; rem_minfree_3="${minfree_3%%,*}"
        minfree_4="${minfree_3#*,}" ; rem_minfree_4="${minfree_4%%,*}"
        minfree_5="${minfree_4#*,}"

        vmpres_file_min=$((minfree_5 + (minfree_5 - rem_minfree_4)))
        echo $vmpres_file_min > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
        if [ $MemTotal -lt 3145728 ]; then
            echo "18432,23040,27648,32256,100640,120640" > /sys/module/lowmemorykiller/parameters/minfree
        elif [ $MemTotal -lt 4194304 ]; then
            echo "18432,23040,27648,38708,120640,144768" > /sys/module/lowmemorykiller/parameters/minfree
        elif [ $MemTotal -lt 6291456 ]; then
            echo "18432,23040,27648,64512,165888,225792" > /sys/module/lowmemorykiller/parameters/minfree
        else
            echo "18432,23040,27648,96768,276480,362880" > /sys/module/lowmemorykiller/parameters/minfree
        fi
    else
        # Set LMK series, vmpressure_file_min for 32 bit non-go targets.
        # Disable Core Control, enable KLMK for non-go 8909.
        if [ "$ProductName" == "msm8909" ]; then
            disable_core_ctl
            echo 1 > /sys/module/lowmemorykiller/parameters/enable_lmk
        fi
        echo "15360,19200,23040,26880,34415,43737" > /sys/module/lowmemorykiller/parameters/minfree
        echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
    fi

    # Enable adaptive LMK for all targets &
    # use Google default LMK series for all 64-bit targets >=2GB.
    echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk

    # Enable oom_reaper
    if [ -f /sys/module/lowmemorykiller/parameters/oom_reaper ]; then
        echo 1 > /sys/module/lowmemorykiller/parameters/oom_reaper
    fi

        #bengal has appcompaction enabled. So not needed
        # Set PPR parameters for other targets
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        #Set PPR parameters for all other targets.
        echo $set_almk_ppr_adj > /sys/module/process_reclaim/parameters/min_score_adj
        echo 0 > /sys/module/process_reclaim/parameters/enable_process_reclaim
        echo 50 > /sys/module/process_reclaim/parameters/pressure_min
        echo 70 > /sys/module/process_reclaim/parameters/pressure_max
        echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
        echo 512 > /sys/module/process_reclaim/parameters/per_swap_size

    # Set allocstall_threshold to 0 for all targets.
    # Set swappiness to 100 for all targets
    echo 0 > /sys/module/vmpressure/parameters/allocstall_threshold
    echo 100 > /proc/sys/vm/swappiness

    # Disable wsf for all targets beacause we are using efk.
    # wsf Range : 1..1000 So set to bare minimum value 1.
    echo 10 > /proc/sys/vm/watermark_scale_factor

    configure_zram_parameters

    configure_read_ahead_kb_values

    enable_swap
}

function enable_memory_features()
{
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    if [ $MemTotal -le 2097152 ]; then
        #Enable B service adj transition for 2GB or less memory
        setprop ro.vendor.qti.sys.fw.bservice_enable true
        setprop ro.vendor.qti.sys.fw.bservice_limit 5
        setprop ro.vendor.qti.sys.fw.bservice_age 5000

        #Enable Delay Service Restart
        setprop ro.vendor.qti.am.reschedule_service true
    fi
}

case "sm6150" in
    "sm6150")

        #Apply settings for sm6150
        # Set the default IRQ affinity to the silver cluster. When a
        # CPU is isolated/hotplugged, the IRQ affinity is adjusted
        # to one of the CPU from the default IRQ affinity mask.
        echo 3f > /proc/irq/default_smp_affinity

        if [ -f /sys/devices/soc0/soc_id ]; then
                soc_id=`cat /sys/devices/soc0/soc_id`
        else
                soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        case "$soc_id" in
            "355" | "369" | "377" | "380" | "384" )
      target_type=`getprop ro.hardware.type`
      sku_identified=0

      # Core control parameters on silver
      echo 0 0 0 0 1 1 > /sys/devices/system/cpu/cpu0/core_ctl/not_preferred
      echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
      echo 60 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
      echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
      echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
      echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster
      echo 8 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres
      echo 0 > /sys/devices/system/cpu/cpu6/core_ctl/enable


      # Setting b.L scheduler parameters
      # default sched up and down migrate values are 90 and 85
      echo 65 > /proc/sys/kernel/sched_downmigrate
      echo 71 > /proc/sys/kernel/sched_upmigrate
      # default sched up and down migrate values are 100 and 95
      echo 85 > /proc/sys/kernel/sched_group_downmigrate
      echo 100 > /proc/sys/kernel/sched_group_upmigrate
      echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks

      # colocation v3 settings
      echo 740000 > /proc/sys/kernel/sched_little_cluster_coloc_fmin_khz


      # configure governor settings for little cluster
      echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      if [ $sku_identified != 1 ]; then
        echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
      fi

      # configure governor settings for big cluster
      echo "conservative" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
      echo 0 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/up_rate_limit_us
      echo 0 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/down_rate_limit_us
      echo 1209600 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_freq
      if [ $sku_identified != 1 ]; then
        echo 768000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
      fi

      # sched_load_boost as -6 is equivalent to target load as 85. It is per cpu tunable.
      echo -6 >  /sys/devices/system/cpu/cpu6/sched_load_boost
      echo -6 >  /sys/devices/system/cpu/cpu7/sched_load_boost
      echo 85 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_load

      echo "0:1209600" > /sys/module/cpu_boost/parameters/input_boost_freq
      echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms

      # Set Memory parameters
      configure_memory_parameters

      # Enable bus-dcvs
      for device in /sys/devices/platform/soc
      do
          for cpubw in $device/*cpu-cpu-llcc-bw/devfreq/*cpu-cpu-llcc-bw
          do
	      echo "bw_hwmon" > $cpubw/governor
	      echo "2288 4577 7110 9155 12298 14236" > $cpubw/bw_hwmon/mbps_zones
	      echo 4 > $cpubw/bw_hwmon/sample_ms
	      echo 68 > $cpubw/bw_hwmon/io_percent
	      echo 20 > $cpubw/bw_hwmon/hist_memory
	      echo 0 > $cpubw/bw_hwmon/hyst_length
	      echo 80 > $cpubw/bw_hwmon/down_thres
	      echo 0 > $cpubw/bw_hwmon/guard_band_mbps
	      echo 250 > $cpubw/bw_hwmon/up_scale
	      echo 1600 > $cpubw/bw_hwmon/idle_mbps
              echo 50 > $cpubw/polling_interval
	  done

	  for llccbw in $device/*cpu-llcc-ddr-bw/devfreq/*cpu-llcc-ddr-bw
	  do
	      echo "bw_hwmon" > $llccbw/governor
	      echo "1144 1720 2086 2929 3879 5931 6881" > $llccbw/bw_hwmon/mbps_zones
	      echo 4 > $llccbw/bw_hwmon/sample_ms
	      echo 68 > $llccbw/bw_hwmon/io_percent
	      echo 20 > $llccbw/bw_hwmon/hist_memory
	      echo 0 > $llccbw/bw_hwmon/hyst_length
	      echo 80 > $llccbw/bw_hwmon/down_thres
	      echo 0 > $llccbw/bw_hwmon/guard_band_mbps
	      echo 250 > $llccbw/bw_hwmon/up_scale
	      echo 1600 > $llccbw/bw_hwmon/idle_mbps
              echo 40 > $llccbw/polling_interval
	  done
      done

      # memlat specific settings are moved to seperate file under
      # device/target specific folder
      setprop vendor.dcvs.prop 1

            # cpuset parameters
            echo 0-5 > /dev/cpuset/background/cpus
            echo 0-5 > /dev/cpuset/system-background/cpus

            # Turn off scheduler boost at the end
            echo 0 > /proc/sys/kernel/sched_boost

            # Turn on sleep modes.
            echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
            ;;
        esac

        #Apply settings for moorea
        case "$soc_id" in
            "365" | "366" )

            # Core control parameters on silver
            echo 0 0 0 0 1 1 > /sys/devices/system/cpu/cpu0/core_ctl/not_preferred
            echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
            echo 60 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
            echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
            echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
            echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster
            echo 8 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres
            echo 0 > /sys/devices/system/cpu/cpu6/core_ctl/enable

            # Setting b.L scheduler parameters
            # default sched up and down migrate values are 71 and 65
            echo 65 > /proc/sys/kernel/sched_downmigrate
            echo 71 > /proc/sys/kernel/sched_upmigrate
            # default sched up and down migrate values are 100 and 95
            echo 85 > /proc/sys/kernel/sched_group_downmigrate
            echo 100 > /proc/sys/kernel/sched_group_upmigrate
            echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks

            #colocation v3 settings
            echo 740000 > /proc/sys/kernel/sched_little_cluster_coloc_fmin_khz

            # configure governor settings for little cluster
            echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
            echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

            # configure governor settings for big cluster
            echo "conservative" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor

            # sched_load_boost as -6 is equivalent to target load as 85. It is per cpu tunable.
            echo -6 >  /sys/devices/system/cpu/cpu6/sched_load_boost
            echo -6 >  /sys/devices/system/cpu/cpu7/sched_load_boost
            echo 85 > /sys/devices/system/cpu/cpu6/cpufreq/schedutil/hispeed_load

            echo "0:1324800" > /sys/module/cpu_boost/parameters/input_boost_freq
            echo 120 > /sys/module/cpu_boost/parameters/input_boost_ms
            echo "0:1324800 1:0 2:0 3:0 4:0 5:0 6:2169600 7:0" > /sys/module/cpu_boost/parameters/powerkey_input_boost_freq
            echo 400 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms

            # Set Memory parameters
            configure_memory_parameters

            # Enable bus-dcvs
            for device in /sys/devices/platform/soc
            do
                for cpubw in $device/*cpu-cpu-llcc-bw/devfreq/*cpu-cpu-llcc-bw
                do
                    echo "bw_hwmon" > $cpubw/governor
                    echo "2288 4577 7110 9155 12298 14236" > $cpubw/bw_hwmon/mbps_zones
                    echo 4 > $cpubw/bw_hwmon/sample_ms
                    echo 68 > $cpubw/bw_hwmon/io_percent
                    echo 20 > $cpubw/bw_hwmon/hist_memory
                    echo 0 > $cpubw/bw_hwmon/hyst_length
                    echo 80 > $cpubw/bw_hwmon/down_thres
                    echo 0 > $cpubw/bw_hwmon/guard_band_mbps
                    echo 250 > $cpubw/bw_hwmon/up_scale
                    echo 1600 > $cpubw/bw_hwmon/idle_mbps
                    echo 50 > $cpubw/polling_interval
                done

                for llccbw in $device/*cpu-llcc-ddr-bw/devfreq/*cpu-llcc-ddr-bw
                do
                    echo "bw_hwmon" > $llccbw/governor
                    echo "1144 1720 2086 2929 3879 5931 6881" > $llccbw/bw_hwmon/mbps_zones
                    echo 4 > $llccbw/bw_hwmon/sample_ms
                    echo 68 > $llccbw/bw_hwmon/io_percent
                    echo 20 > $llccbw/bw_hwmon/hist_memory
                    echo 0 > $llccbw/bw_hwmon/hyst_length
                    echo 80 > $llccbw/bw_hwmon/down_thres
                    echo 0 > $llccbw/bw_hwmon/guard_band_mbps
                    echo 250 > $llccbw/bw_hwmon/up_scale
                    echo 1600 > $llccbw/bw_hwmon/idle_mbps
                    echo 40 > $llccbw/polling_interval
                done

                for npubw in $device/*npu-npu-ddr-bw/devfreq/*npu-npu-ddr-bw
                do
                    echo 1 > /sys/devices/virtual/npu/msm_npu/pwr
                    echo "bw_hwmon" > $npubw/governor
                    echo "1144 1720 2086 2929 3879 5931 6881" > $npubw/bw_hwmon/mbps_zones
                    echo 4 > $npubw/bw_hwmon/sample_ms
                    echo 80 > $npubw/bw_hwmon/io_percent
                    echo 20 > $npubw/bw_hwmon/hist_memory
                    echo 10 > $npubw/bw_hwmon/hyst_length
                    echo 30 > $npubw/bw_hwmon/down_thres
                    echo 0 > $npubw/bw_hwmon/guard_band_mbps
                    echo 250 > $npubw/bw_hwmon/up_scale
                    echo 0 > $npubw/bw_hwmon/idle_mbps
                    echo 40 > $npubw/polling_interval
                    echo 0 > /sys/devices/virtual/npu/msm_npu/pwr
                done
            done

            # memlat specific settings are moved to seperate file under
            # device/target specific folder
            setprop vendor.dcvs.prop 1

            # cpuset parameters
            echo 0-2     > /dev/cpuset/background/cpus
            echo 0-3     > /dev/cpuset/system-background/cpus
            echo 4-7     > /dev/cpuset/foreground/boost/cpus
            echo 0-2,4-7 > /dev/cpuset/foreground/cpus
            echo 0-7     > /dev/cpuset/top-app/cpus

            # Turn off scheduler boost at the end
            echo 0 > /proc/sys/kernel/sched_boost

            # Turn on sleep modes.
            echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
          ;;
        esac

    ;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
chown -h system /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor
chown -h system /sys/devices/system/cpu/cpufreq/conservative/io_is_busy

emmc_boot=`getprop vendor.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

setprop vendor.post_boot.parsed 1

# Install AdrenoTest.apk if not already installed
if [ -f /data/prebuilt/AdrenoTest.apk ]; then
    if [ ! -d /data/data/com.qualcomm.adrenotest ]; then
        pm install /data/prebuilt/AdrenoTest.apk
    fi
fi

# Install SWE_Browser.apk if not already installed
if [ -f /data/prebuilt/SWE_AndroidBrowser.apk ]; then
    if [ ! -d /data/data/com.android.swe.browser ]; then
        pm install /data/prebuilt/SWE_AndroidBrowser.apk
    fi
fi

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
    image_version="10:"
    image_version+=`getprop ro.build.id`
    image_version+=":"
    image_version+=`getprop ro.build.version.incremental`
    image_variant=`getprop ro.product.name`
    image_variant+="-"
    image_variant+=`getprop ro.build.type`
    oem_version=`getprop ro.build.version.codename`
    echo 10 > /sys/devices/soc0/select_image
    echo $image_version > /sys/devices/soc0/image_version
    echo $image_variant > /sys/devices/soc0/image_variant
    echo $oem_version > /sys/devices/soc0/image_crm_version
fi

# Change console log level as per console config property
console_config=`getprop persist.vendor.console.silent.config`
case "$console_config" in
    "1")
        echo "Enable console config to $console_config"
        echo 0 > /proc/sys/kernel/printk
        ;;
    *)
        echo "Enable console config to $console_config"
        ;;
esac

# Parse misc partition path and set property
misc_link=$(ls -l /dev/block/bootdevice/by-name/misc)
real_path=${misc_link##*>}
setprop persist.vendor.mmi.misc_dev_path $real_path
