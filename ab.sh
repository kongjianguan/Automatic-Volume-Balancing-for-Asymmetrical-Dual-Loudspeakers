# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 该脚本将在设备开机后作为延迟服务启动
MODNAME="Automatic_balancing_of_Dual_Loudspeakers"
MODCONF="/data/${MODNAME}.conf"
until [ -d "/sdcard/Android" ]; do
    sleep 1
done
echo $(date)启动 >./log.txt
if [ ! -f ${MODCONF} ]; then
    echo "volume_offset=0.0">"/data/${MODNAME}.conf"
    chmod 755 $MODCONF
fi
chmod -R 755 .
function mycat(){
    echo $(awk -F"$1" '{print $2}' "$MODCONF")
}
function check() { 
     dumplog=$(dumpsys audio | grep "Devices:") 
  
     dev=("bt_a2dp" 
     "headphone" 
     "headset" 
     "usb_headset" 
     "bt_a2dp_hp" 
     "bt_sco_hs" 
     "remote_submix" 
     "ble_headset") 
  
     ep=("蓝牙耳机一类" 
     "有线耳机一类" 
     "有线耳机二类" 
     "USB耳机" 
     "蓝牙耳机二类" 
     "蓝牙耳机三类" 
     "远程音频" 
     "蓝牙耳机四类(LC3)") 
  
     for i in "${!dev[@]}"; do 
         if echo "$dumplog" | grep -i "Devices: ${dev[i]}" >/dev/null; then 
             echo "${ep[i]}已连接" 
             return 0 
         fi 
     done 
  
      return 1 
  }

temp=0.0
vol=0.0
if [ -f ${MODCONF} ];then
echo "conf found"
volume_offset=$(mycat "volume_offset=")
else volume_offset=0.0
fi
while true;
do
    check
    if [ $? == 0 ]; then
        setenforce 0
        settings put system master_balance $vol
    elif [ $? == 1 ]; then
        setenforce 0
        temp=$(settings get system master_balance)
        if [ $temp != $vol ]; then
            volume_offset=$temp
        else
            volume_offset=$(mycat "volume_offset=")
        fi
        echo "volume_offset="$volume_offset > ${MODCONF}
        settings put system master_balance $volume_offset
        echo "Now the volume_offset = "$volume_offset
    fi
    setenforce 1
    sleep 5
done
