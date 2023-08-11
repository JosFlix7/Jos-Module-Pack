# Información basica para Magisk
AUTOMOUNT=true
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

# Informacion Extra
  ui_print "*******************************************************"
  ui_print "   Pack de modulos privado."
  ui_print "   La amalgama personal de JosFlix7!"
  ui_print "   Para Android 10+ AOSP"
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
  ui_print "   - Disable Unwanted Google Play Service v1.2.5 by Ndik"
  ui_print "   - GPU Turbo Boost (Ocean Tiramisu Mod) v6.2.1 by EmperorEye1993 & JosFlix7"
  ui_print "   "
  ui_print "   TOTAL: 18"
  ui_print "   (Varia dependiendo la version de Android)"
  ui_print "*******************************************************"

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
ui_print "- Iniciando modificacion"
sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;/sae_enabled=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nsae_enabled=1\nEND/g' $MODPATH$SELECTPATH
}
done
[[ -z $SELECTPATH ]] && abort "- Instalacion FALLIDA. Tu dispositivo no soporta WCNSS_qcom_cfg.ini." || { mkdir -p $MODPATH/system; mv -f $MODPATH/vendor $MODPATH/system/vendor; mv -f $MODPATH/product $MODPATH/system/product; mv -f $MODPATH/system_ext $MODPATH/system/system_ext;}

# Descompresión del módulo
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

# Deteccion y aplicacion de módulos por API de Android
ui_print "- Detectando version de Android"
CODENAME=$(getprop ro.build.version.sdk)
if [[ "$CODENAME" == "33" ]]; then
  mkdir -p "$MODPATH"/system/priv-app/ExternalStorageProvider
  mkdir -p "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/ExternalStorageProvider_T/* "$MODPATH"/system/priv-app/ExternalStorageProvider
  cp -rf "$MODPATH"/Apps/WallZoomAnim "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/vendor "$MODPATH"/system
elif [[ "$CODENAME" == "32" ]]; then
  mkdir -p "$MODPATH"/system/priv-app/ExternalStorageProvider
  mkdir -p "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/ExternalStorageProvider_S/* "$MODPATH"/system/priv-app/ExternalStorageProvider
  cp -rf "$MODPATH"/Apps/WallZoomAnim "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/vendor "$MODPATH"/system
elif [[ "$CODENAME" == "31" ]]; then
  mkdir -p "$MODPATH"/system/priv-app/ExternalStorageProvider
  mkdir -p "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/ExternalStorageProvider_S/* "$MODPATH"/system/priv-app/ExternalStorageProvider
  cp -rf "$MODPATH"/Apps/WallZoomAnim "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/vendor "$MODPATH"/system
elif [[ "$CODENAME" == "30" ]]; then
  mkdir -p "$MODPATH"/system/priv-app/ExternalStorageProvider
  mkdir -p "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/ExternalStorageProvider_R/* "$MODPATH"/system/priv-app/ExternalStorageProvider
  cp -rf "$MODPATH"/Apps/WallZoomAnim "$MODPATH"/system/product/overlay
  cp -rf "$MODPATH"/Apps/vendor "$MODPATH"/system
elif [[ "$CODENAME" == "29" ]]; then
  mkdir -p "$MODPATH"/system/priv-app/ExternalStorageProvider
  cp -rf "$MODPATH"/Apps/ExternalStorageProvider_Q/* "$MODPATH"/system/priv-app/ExternalStorageProvider
  cp -rf "$MODPATH"/Apps/vendor "$MODPATH"/system
fi

# Eliminacion de carpeta innecesaria
rm -rf "$MODPATH"/Apps

# Replace Target
REPLACE="
/system/priv-app/ExternalStorageProvider
"
# Ajustar Permisos
ui_print "- Ajustando permisos"
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm_recursive $MODPATH/system/bin 0 0 0777 0755
  set_perm  $MODPATH/system/bin/logd  0  0  0550

# Close Logd Functions
ui_print "- Ejecutando funciones personalizadas"
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
