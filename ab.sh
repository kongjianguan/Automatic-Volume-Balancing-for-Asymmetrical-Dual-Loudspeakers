
cbev=2
temp=0
volume_offset=0
MODNAME="Automatic_balancing_of_Dual_Loudspeakers"
MODCONF="/data/${MODNAME}.conf"

function mycat(){
    temp1=$(awk -F"$1" '{print $2}' "$MODCONF")
    echo temp1
}
while [ $cbev != 1 ];
do
    BT_CONNECTED=$(dumpsys bluetooth_manager | grep "mCurrentDevice: null")
    if [ ! -n "$BT_CONNECTED" ]; then
        cbev=1
    else
        cbev=0
    fi
    if [ $cbev == 1 ]; then
        echo "Bluetooth earphones connected"
        settings put system master_balance 0.0
    elif [ $cbev == 0 ]; then
        temp=$(settings get system master_balance)
        if [ ! $temp == 0.0 ]; then
            volume_offset=$temp
        else
            volume_offset=$(mycat "volume_offset=")
        fi
        echo ${volume_offset}
        echo "volume_offset="$volume_offset > ${MODCONF}
        echo "No Bluetooth earphones connected"
        settings put system master_balance $volume_offset
    fi
    sleep 1
done