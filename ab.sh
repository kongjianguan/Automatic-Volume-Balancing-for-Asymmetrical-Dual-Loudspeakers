cbev=2
temp=0.0
volume_offset=0.0
MODNAME="Automatic_balancing_of_Dual_Loudspeakers"
MODCONF="/data/${MODNAME}.conf"

function mycat(){
    echo $(awk -F"$1" '{print $2}' "$MODCONF")
}
while true;
do
    dumpsys audio | grep "Devices: bt_a2dp"
    if [ $? == 0 ]; then
        cbev=1
        echo "Bluetooth earphones connected"
    else
        cbev=0
        echo "No Bluetooth earphones connected"
    fi
    dumpsys audio | grep "Devices: headphone" >/dev/null
    if [ $? != 0 ];then
        echo "有线耳机未连接"
        cbfv=0
    else
        echo "有线耳机已连接"
        cbfv=1
    fi
    if [ $cbev == 1 ]; then
        settings put system master_balance 0.0
    elif [ $cbfv == 1 ];then
        settings put system master_balance 0.0
    elif [ $cbev == 0 ] && [ $cbfv == 0 ]; then
        temp=$(settings get system master_balance)
        if [ ! $temp == 0.0 ]; then
            volume_offset=$temp
        else
            volume_offset=$(mycat "volume_offset=")
        fi
        echo "volume_offset="$volume_offset > ${MODCONF}
        settings put system master_balance $volume_offset
    fi
    echo "Now the volume_offset = "$(settings get system master_balance)
    sleep 1
done