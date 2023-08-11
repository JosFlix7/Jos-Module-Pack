# Standard Magisk Uninstall
if [ -f $INFO ]; then
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $INFO
  rm -f $INFO
fi

# Performance Activity Manager
function boot_wait() {
 while [[ -z $(getprop sys.boot_completed) ]]; do sleep 5; done
}
function system_table_unset() {
  settings delete system "$1"
}
boot_wait
system_table_unset activity_manager_constants

# Close Logd
#!/system/bin/sh
/sbin/.magisk/busybox/chattr -i -a -A /cache/magisk.log
chmod 777 /cache/magisk.log
/sbin/.magisk/busybox/chattr -i -a -A /data/user_de/0/com.solohsu.android.edxp.manager/log
chmod 777 /data/user_de/0/com.solohsu.android.edxp.manager/log
/sbin/.magisk/busybox/chattr -i -a -A /data/user_de/0/org.meowcat.edxposed.manager/log
chmod 777 /data/user_de/0/org.meowcat.edxposed.manager/log
/sbin/.magisk/busybox/chattr -i -a -A /data/user_de/0/com.miui.home/cache/debug_log
chmod 777 /data/user_de/0/com.miui.home/cache/debug_log

rm -rf /data/user_de/0/com.miui.home/cache/debug_log
rm -rf /data/user_de/0/org.meowcat.edxposed.manager/log
rm -rf  /data/user_de/0/com.solohsu.android.edxp.manager/log

then 