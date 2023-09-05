AUTOMOUNT=true
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

ui_print "*******************************************************"
ui_print "   Pack de modulos personal."
ui_print "   La amalgama personal de JosFlix7!"
ui_print "   Para Android 8~13 AOSP con procesador Snapdragon"
ui_print "   -------------------------------------------------   "
ui_print "          Mods Incluidos:"
ui_print "   - 8 Bits Rendering v1 by JosFlix7"
ui_print "   - Fuse PassThrough v1 by JosFlix7"
ui_print "   - Persist Sys Purgeable Assets v1 by JosFlix7"
ui_print "   - Disable Unnecessary Things v1.5 by @zaidannn7"
ui_print "   - No Storage Restrict v5 by DanGLES3"
ui_print "   - Wallpaper Zoom Disabler v1 by @Hamido"
ui_print "   - Bye Blur v2 by @modulostk"
ui_print "   - ByeShit v666.7 by @nonosvaimos"
ui_print "   - APN Fix v1 by JosFlix7"
ui_print "   - Wifi Bonding (Qcom) v1.15 by simonsmh"
ui_print "   - Moto Widget Permissions v4.09.15 by Hamido & Amr"
ui_print "   - Performance Activity Manager v1 by @Haruu1416"
ui_print "   - SkiaGL Optimization v2 by @zaidannn7 & @modulostk"
ui_print "   - Scroll Optimization v1 by @zaidannn7"
ui_print "   - Disable Client Composition Cache v1 by @zaidannn7"
ui_print "   - Close Logd v7 by 旧梦, @头露基基 & @杀鲸"
ui_print "   - Fresh UI v1.0 by @nonosvaimos"
ui_print "   - Rendering v1.2 by @nonosvaimos"
ui_print "   - GPUTurboBoostTiramisu v6.2.1 by EmperorEye1993 & JosFlix7"
ui_print "   - LowRAM-Flag Plus (Without LowRAM Prop) v3.2 by JosFlix7"
ui_print "   -------------------------------------------------   "
ui_print "   TOTAL: 20"
ui_print "*******************************************************"

ui_print "- Descomprimiendo modulo."
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

ui_print "- Iniciando modificaciones."
# WiFI Bonding Script
[ -x "$(which magisk)" ] && MIRRORPATH=$(magisk --path)/.magisk/mirror || unset MIRRORPATH
array=$(find /system /vendor /product /system_ext -name WCNSS_qcom_cfg.ini)
for CFG in $array
do
[[ -f $CFG ]] && [[ ! -L $CFG ]] && {
SELECTPATH=$CFG
mkdir -p `dirname $MODPATH$CFG`
ui_print "- Migrando $MIRRORPATH$SELECTPATH"
cp -af $MIRRORPATH$SELECTPATH $MODPATH$SELECTPATH
ui_print "- Creando archivos."
sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;/sae_enabled=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nsae_enabled=1\nEND/g' $MODPATH$SELECTPATH
}
done
[[ -z $SELECTPATH ]] && abort "- Instalacion FALLIDA. Tu dispositivo no soporta WCNSS_qcom_cfg.ini." || { mkdir -p $MODPATH/system; mv -f $MODPATH/vendor $MODPATH/system/vendor; mv -f $MODPATH/product $MODPATH/system/product; mv -f $MODPATH/system_ext $MODPATH/system/system_ext;}

ui_print "- Detectando version de Android."
A_API=$(getprop ro.build.version.sdk)
A_VER=$(getprop ro.build.version.release)
A_TEXT="- Android $A_VER (API $A_API) detectado."
REPLACE_NSR="/system/priv-app/ExternalStorageProvider"
CREATE_NSR="$MODPATH/system/priv-app/ExternalStorageProviderNSR"
COPY_NSR="$MODPATH/Apps"
NEW_NSR="$MODPATH/system/priv-app/ExternalStorageProviderNSR"
CREATE_OVERLAY="$MODPATH/system/product/overlay"
COPY_WALL="$MODPATH/Apps/WallZoomAnim"
DIR_OVERLAY="$MODPATH/system/product/overlay"
COPY_VENDOR="$MODPATH/Apps/vendor"
DIR_SYSTEM="$MODPATH/system"

if [[ $A_API == 33 ]]; then
  ui_print "$A_TEXT"
  mkdir -p "$CREATE_NSR"
  cp -rf "$COPY_NSR"/ExternalStorageProvider_T/* "$NEW_NSR"
  mkdir -p "$CREATE_OVERLAY"
  cp -rf "$COPY_WALL" "$DIR_OVERLAY"
  cp -rf "$COPY_VENDOR" "$DIR_SYSTEM"
elif [[ $A_API == 31 ]] || [[ $A_API == 32 ]]; then
  ui_print "$A_TEXT"
  mkdir -p "$CREATE_NSR"
  cp -rf "$COPY_NSR"/ExternalStorageProvider_S/* "$NEW_NSR"
  mkdir -p "$CREATE_OVERLAY"
  cp -rf "$COPY_WALL" "$DIR_OVERLAY"
  cp -rf "$COPY_VENDOR" "$DIR_SYSTEM"
elif [[ $A_API == 30 ]]; then
  ui_print "$A_TEXT"
  mkdir -p "$CREATE_NSR"
  cp -rf "$COPY_NSR"/ExternalStorageProvider_R/* "$NEW_NSR"
  mkdir -p "$CREATE_OVERLAY"
  cp -rf "$COPY_WALL" "$DIR_OVERLAY"
  cp -rf "$COPY_VENDOR" "$DIR_SYSTEM"
elif [[ $A_API -le 29 ]]; then
  ui_print "$A_TEXT"
  REPLACE_NSR=""
  cp -rf "$COPY_VENDOR" "$DIR_SYSTEM"
fi

ui_print "- Eliminando archivos temporales."
rm -rf "$MODPATH"/Apps

REPLACE="
$REPLACE_NSR
"

ui_print "- Ajustando permisos."
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive $MODPATH/system/bin 0 0 0777 0755
set_perm  $MODPATH/system/bin/logd  0  0  0550

ui_print "- Ejecutando funciones personalizadas."
# Close Logd Functions
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