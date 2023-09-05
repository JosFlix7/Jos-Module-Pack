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
ui_print "          Mods Complementarios Incluidos:"
ui_print "   - Moto Widget App v4.09.11 by Ayra Hikari"
ui_print "   - Ocean JosFlix7 Bootanimation v1 by JosFlix7"
ui_print "   -------------------------------------------------   "
ui_print "   TOTAL: 2"
ui_print "*******************************************************"

ui_print "- Descomprimiendo modulo."
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

ui_print "- Detectando version de Android."
A_API=$(getprop ro.build.version.sdk)
A_VER=$(getprop ro.build.version.release)
A_TEXT="- Android $A_VER (API $A_API) detectado."

if [[ $A_API -ge 31 && $A_API -le 33 ]]; then
  ui_print "$A_TEXT"
  mkdir -p "$MODPATH"/system/product/priv-app
  cp -rf "$MODPATH"/Apps/MotoWidget "$MODPATH"/system/product/priv-app
elif [[ $A_API -le 30 ]]; then
  ui_print "$A_TEXT"
fi

ui_print "- Eliminando archivos temporales."
rm -rf "$MODPATH"/Apps

REPLACE="
/system/product/media/bootanimation.zip
"

ui_print "- Ajustando permisos."
set_perm_recursive $MODPATH 0 0 0755 0644
