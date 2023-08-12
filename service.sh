# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 该脚本将在设备开机后作为延迟服务启动
MODNAME="Automatic_balancing_of_Dual_Loudspeakers"
MODCONF="/data/${MODNAME}.conf"
until [ -d "/sdcard/Android" ]; do
    sleep 1
done
if [ ! -d ${MODCONF} ]; then
    echo "volume_offset=0.0">"/data/${MODNAME}.conf"
    chmod 777 $MODCONF
fi
chmod -R 777 .
while true; do
   pgrep -f ${MODDIR}/ab.sh
   if [ $? -ne 0 ]; then
        chmod 777 ${MODDIR}/ab.sh
        sh "${MODDIR}/ab.sh"
   fi
   sleep 60 # 每两分钟检查一次
done




