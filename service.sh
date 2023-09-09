#!/system/bin/sh
MODDIR=${0%/*}

# Resetprop para ajustar props dependiendo la version de Android
A_API=$(getprop ro.build.version.sdk)
if [[ $A_API -ge 31 ]]; then
  # GPU Turbo Boost Fork
  resetprop debug.composition.type auto
  resetprop persist.sys.composition.type auto
  resetprop debug.sf.enable_gl_backpressure 0
  # Rendering
  resetprop debug.sf.disable_backpressure 1
elif [[ $A_API -le 30 ]]; then
  # GPU Turbo Boost Fork
  resetprop debug.composition.type c2d
  resetprop debug.composition.type gpu
  resetprop persist.sys.composition.type c2d
  resetprop persist.sys.composition.type gpu
  resetprop debug.sf.enable_gl_backpressure 1
  # Rendering
  resetprop debug.sf.disable_backpressure 0
fi
# Reset SurfaceFlinger
service call SurfaceFlinger 1008

# Dalvik VM Heap Dynamic Config (Makes system uses less RAM)
# 3670016 KB = 3.5 GB | My Ocean 4GB variant have 3645760 KB
RAM_T=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
if [[ $RAM_T -lt 3600000 ]]; then
  resetprop dalvik.vm.heapstartsize 8m
  resetprop dalvik.vm.heapgrowthlimit 64m
  resetprop dalvik.vm.heapsize 128m
  resetprop dalvik.vm.heaptargetutilization 0.75
  resetprop dalvik.vm.heapminfree 2m
  resetprop dalvik.vm.heapmaxfree 8m
elif [[ $RAM_T -gt 3600000 ]]; then
  resetprop dalvik.vm.heapstartsize
  resetprop dalvik.vm.heapgrowthlimit
  resetprop dalvik.vm.heapsize
  resetprop dalvik.vm.heaptargetutilization
  resetprop dalvik.vm.heapminfree
  resetprop dalvik.vm.heapmaxfree
fi

# GPU Turbo Boost Fork Script
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor performance
write /sys/devices/system/cpu/cpufreq/policy0/scaling_governor performance
write /sys/devices/system/cpu/cpufreq/policy4/scaling_governor performance
write /sys/devices/system/cpu/cpufreq/performance/above_hispeed_delay 0
write /sys/devices/system/cpu/cpufreq/performance/boost 1
write /sys/devices/system/cpu/cpufreq/performance/go_hispeed_load 75
write /sys/devices/system/cpu/cpufreq/performance/max_freq_hysteresis 1
write /sys/devices/system/cpu/cpufreq/performance/align_windows 1
write /sys/kernel/gpu/gpu_governor performance
write /sys/module/adreno_idler/parameters/adreno_idler_active 0
write /sys/module/lazyplug/parameters/nr_possible_cores 8
write /sys/module/msm_performance/parameters/touchboost 1
write /dev/cpuset/foreground/boost/cpus 4-7
write /dev/cpuset/foreground/cpus 0-3,4-7
write /dev/cpuset/top-app/cpus 0-7

# Close Logd Script
sleep 5
am kill logd
killall -9 logd
am kill logd.rc
killall -9 logd.rc
sleep 10
echo 3 > /proc/sys/vm/drop_caches
echo 1 > /proc/sys/vm/compact_memory
rm -rf /data/vendor/wlan_logs
touch /data/vendor/wlan_logs
chmod 000 /data/vendor/wlan_logs

# Performance Activity Manager Script
function boot_wait() {
 while [[ -z $(getprop sys.boot_completed) ]]; do sleep 5; done
}
function system_table_set() {
  settings put system "$1" "$2"
}
boot_wait
system_table_set activity_manager_constants max_cached_processes=0,background_settle_time=60000,fgservice_min_shown_time=2000,fgservice_min_report_time=3000,fgservice_screen_on_before_time=1000,fgservice_screen_on_after_time=5000,content_provider_retain_time=20000,gc_timeout=5000,gc_min_interval=60000,full_pss_min_interval=1200000,full_pss_lowered_interval=300000,power_check_interval=300000,power_check_max_cpu_1=0,power_check_max_cpu_2=0,power_check_max_cpu_3=0,power_check_max_cpu_4=0,service_usage_interaction_time=1800000,usage_stats_interaction_interval=7200000,service_restart_duration=1000,service_reset_run_duration=60000,service_restart_duration_factor=0,service_min_restart_time_between=10000,service_max_inactivity=1800000,service_bg_start_timeout=15000,CUR_MAX_CACHED_PROCESSES=0,CUR_MAX_EMPTY_PROCESSES=0,CUR_TRIM_EMPTY_PROCESSES=0,CUR_TRIM_CACHED_PROCESSES=0

# Disable unnecessary things Execute script.
while [[ "$(getprop sys.boot_completed)" -ne 1 ]] && [[ ! -d "/sdcard" ]]
do
       sleep 5
done
sleep 40
disableunc
