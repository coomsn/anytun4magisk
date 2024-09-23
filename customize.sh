#!/system/bin/sh
#####################
# anytun Customization
#####################
SKIPUNZIP=1
ASH_STANDALONE=1
unzip_path="/data/adb"

ui_print "- 正在释放文件"
unzip -o "$ZIPFILE" 'anytun/*' -d $unzip_path >&2
unzip -j -o "$ZIPFILE" 'anytun_service.sh' -d /data/adb/service.d >&2
unzip -j -o "$ZIPFILE" 'uninstall.sh' -d $MODPATH >&2
unzip -j -o "$ZIPFILE" "module.prop" -d $MODPATH >&2
ui_print "- 正在设置权限"
set_perm_recursive $MODPATH 0 0 0755 0755
set_perm_recursive /data/adb/anytun/ 0 3005 0755 0755
set_perm /data/adb/service.d/anytun_service.sh 0 0 0755
set_perm $MODPATH/uninstall.sh 0 0 0755
ui_print "- 完成权限设置"

ui_print "- enjoy!"
