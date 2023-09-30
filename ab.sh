function mycat(){
    echo $(awk -F"$1" '{print $2}' "$MODCONF")
}
function check(){
    dumplog=$( dumpsys audio | grep "Devices:")
    echo $dumplog | grep "Devices: bt_a2dp" -i
    if [ $? == 0 ]; then
        echo "蓝牙耳机一类已连接"
        return 0
    else
        echo "蓝牙耳机一类未连接"
    fi
    echo $dumplog | grep "Devices: headphone" -i
    if [ $? == 0 ]; then
        echo "有线耳机一类已连接"
        return 0
    else
        echo "有线耳机一类未连接"
    fi
    echo $dumplog | grep "Devices: headset" -i
    if [ $? == 0 ]; then
        echo "有线耳机二类已连接"
        return 0
    else
        echo "有线耳机二类未连接"
    fi
    echo $dumplog | grep "Devices: usb_headset" -i
    if [ $? == 0 ]; then
        echo "USB耳机已连接"
        return 0
    else
        echo "USB耳机未连接"
    fi
    echo $dumplog | grep "Devices: bt_a2dp_hp" -i
    if [ $? == 0 ]; then
        echo "蓝牙耳机二类已连接"
        return 0
    else
        echo "蓝牙耳机二类未连接"
    fi
    echo $dumplog | grep "Devices: bt_sco_hs" -i
    if [ $? == 0 ]; then
        echo "蓝牙耳机三类已连接"
        return 0
    else
        echo "蓝牙耳机三类未连接"
    fi
    echo $dumplog | grep "Devices: remote_submix" -i
    if [ $? == 0 ]; then
        echo "远程音频已连接"
        return 0
    else 
        echo "远程音频未连接"
    fi
    echo $dumplog | grep "Devices: ble_headset" -i
    if [ $? == 0 ]; then
        echo "蓝牙耳机四类已连接(LC3)"
        return 0
    else
        echo "蓝牙耳机四未连接"
    fi
    return 1
}

temp=0.0
MODNAME="Automatic_balancing_of_Dual_Loudspeakers"
MODCONF="/data/${MODNAME}.conf"
if [ -f ${MODCONF} ];then
volume_offset=$(mycat "volume_offset=")
else volume_offset=0.0
fi

while true;
do
    check
    if [ $? == 0 ]; then
        settings put system master_balance 0.0
    elif [ $? == 1 ]; then
        temp=$(settings get system master_balance)
        if [ $temp != 0.0 ]; then
            volume_offset=$temp
        else
            volume_offset=$(mycat "volume_offset=")
        fi
        echo "volume_offset="$volume_offset > ${MODCONF}
        settings put system master_balance $volume_offset
    fi
    echo "Now the volume_offset = "$(settings get system master_balance)
    sleep 3
done
