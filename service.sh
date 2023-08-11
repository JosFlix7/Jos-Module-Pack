#!/system/bin/sh
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

# Scroll Optimization Script
resetprop ro.vendor.perf.scroll_opt true
resetprop persist.sys.scrollingcache 2
echo "0-7" >/dev/cpuset/foreground/cpus

# Disable unnecessary things Execute script.
while [[ "$(getprop sys.boot_completed)" -ne 1 ]] && [[ ! -d "/sdcard" ]]
do
       sleep 5
done
sleep 40
disableunc
