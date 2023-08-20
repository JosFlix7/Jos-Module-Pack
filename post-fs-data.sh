#!/system/bin/sh
MODDIR=${0%/*}

#GPU Turbo Boost Tiramisu Script
write /proc/sys/vm/page-cluster 0
write /sys/block/zram0/max_comp_streams 4
# Set zram configurations
setprop ro.vendor.qti.config.zram true

# Close Logd post-fs-data mode Script
if
rm -rf /cache/magisk.log
touch   /cache/magisk.log
chmod 000  /cache/magisk.log
/sbin/.magisk/busybox/chattr +i  /cache/magisk.log
rm -rf  /data/user_de/0/com.solohsu.android.edxp.manager/log
touch    /data/user_de/0/com.solohsu.android.edxp.manager/log
chmod 000   /data/user_de/0/com.solohsu.android.edxp.manager/log
/sbin/.magisk/busybox/chattr +i   /data/user_de/0/com.solohsu.android.edxp.manager/log
rm -rf /data/user_de/0/org.meowcat.edxposed.manager/log
touch   /data/user_de/0/org.meowcat.edxposed.manager/log
chmod 000  /data/user_de/0/org.meowcat.edxposed.manager/log
/sbin/.magisk/busybox/chattr +i  /data/user_de/0/org.meowcat.edxposed.manager/log
rm -rf /data/user_de/0/com.miui.home/cache/debug_log
touch   /data/user_de/0/com.miui.home/cache/debug_log
chmod 000  /data/user_de/0/com.miui.home/cache/debug_log 
then
echo "Limpieza completada"
fi
# disable I/O debugging
echo 0 > /sys/block/dm-0/queue/iostats
echo 0 > /sys/block/mmcblk0/queue/iostats
echo 0 > /sys/block/mmcblk0rpmb/queue/iostats
echo 0 > /sys/block/mmcblk1/queue/iostats
echo 0 > /sys/block/loop0/queue/iostats
echo 0 > /sys/block/loop1/queue/iostats
echo 0 > /sys/block/loop2/queue/iostats
echo 0 > /sys/block/loop3/queue/iostats
echo 0 > /sys/block/loop4/queue/iostats
echo 0 > /sys/block/loop5/queue/iostats
echo 0 > /sys/block/loop6/queue/iostats
echo 0 > /sys/block/loop7/queue/iostats
echo 0 > /sys/block/sda/queue/iostats

# Fresh UI Script
rm -rf /data/data/com.android.systemui/cache/*
rm -rf /data/data/com.android.systemui/code_cache/*
rm -rf /data/user_de/0/com.android.systemui/cache/*
rm -rf /data/user_de/0/com.android.systemui/code_cache/*
rm -rf /data/user/0/com.android.systemui/cache/*
rm -rf /data/user/0/com.android.systemui/code_cache/*
