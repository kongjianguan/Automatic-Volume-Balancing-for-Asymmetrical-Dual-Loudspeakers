#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<limits.h>
#include<string>
using namespace std;
#define MODNAME "Automatic_balancing_of_Dual_Loudspeakers"
FILE* MODCONF =fopen("/data/Automatic_balancing_of_Dual_Loudspeakers.conf","r+");
char* temp=malloc(100*sizeof(char));
string offset;
inline string& mycat(){
    if(access("/data/Automatic_balancing_of_Dual_Loudspeakers.conf",F_OK)){
        return "error";   
    }
    fgets(temp,100,MODCONF);
    int i,l=i=strlen(temp);
    while(temp[i--]!='=' || i){}
    i+=2;
    if(i>=(l-1)){
        return NULL;
    }
    l=0;
    while(temp[i]){
        offest[l]=temp[i];
        ++l;
        ++i;
    }
    return offset;
    //已完整，待测试
}
check
int main(){
    char* MODDIR=realpath("./",MODDIR);
    while(true){
        if(mycat()==NULL) continue;
        
        //printf("%s\n",MODDIR);
    }
}
/*
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
         else 
             echo "${ep[i]}未连接" 
         fi 
     done 
  
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
*/