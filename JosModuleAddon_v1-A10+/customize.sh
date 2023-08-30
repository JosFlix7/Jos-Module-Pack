#Informacion para Magisk
AUTOMOUNT=true
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

ui_print "*******************************************************"
ui_print "   Pack de modulos privado."
ui_print "   La amalgama personal de JosFlix7!"
ui_print "   Para Android 10+ AOSP"
ui_print "   -------------------------------------------------   "
ui_print "          Mods Complementarios Incluidos:"
ui_print "   - Moto Widget App v4.09.11 by Ayra Hikari"
ui_print "   - Ocean JosFlix7 Bootanimation v1 by JosFlix7"
ui_print "   -------------------------------------------------   "
ui_print "   TOTAL: 2"
ui_print "*******************************************************"

ui_print "- Descomprimiendo modulo."
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

ui_print "- Detectando version de Android."
CODENAME=$(getprop ro.build.version.sdk)
if [[ "$CODENAME" == "33" ]]; then
  ui_print "- Android 13 (API 33) detectado."
  mkdir -p "$MODPATH"/system/product/priv-app
  cp -rf "$MODPATH"/Apps/MotoWidget "$MODPATH"/system/product/priv-app
elif [[ "$CODENAME" == "32" ]]; then
  ui_print "- Android 12L (API 32) detectado."
  mkdir -p "$MODPATH"/system/product/priv-app
  cp -rf "$MODPATH"/Apps/MotoWidget "$MODPATH"/system/product/priv-app
elif [[ "$CODENAME" == "31" ]]; then
  ui_print "- Android 12 (API 31) detectado."
  mkdir -p "$MODPATH"/system/product/priv-app
  cp -rf "$MODPATH"/Apps/MotoWidget "$MODPATH"/system/product/priv-app
elif [[ "$CODENAME" == "30" ]]; then
  ui_print "- Android 11 (API 30) detectado."
elif [[ "$CODENAME" == "29" ]]; then
  ui_print "- Android 10 (API 29) detectado."
fi

ui_print "- Eliminando archivos temporales."
rm -rf "$MODPATH"/Apps

REPLACE="
/system/product/media/bootanimation.zip
"

ui_print "- Ajustando permisos."
set_perm_recursive $MODPATH 0 0 0755 0644
