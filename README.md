# 非对称双扬自动平衡

# Automatic Volume Balancing for Asymmetrical Dual Loudspeakers

该模块通过识别当前音频输出设备连接状态自动调整Android11+的音量平衡偏移值

This module automatically adjusts the volume offset for Android 11 and above by identifying the current audio output device connection status

模块刷入后只需要在无外置音频输出设备连接的情况下调整音量平衡的参数，脚本就会自动写入配置，重启后也无需再次调参

After the module is brushed in, you only need to adjust the parameters of the volume offset value without the connection of the external audio output device. No need to adjust the parameters again after reboot

# 问题自查

## 按顺序来

终端输入
```
su
ps -elf | grep Automatic_balancing_of_Dual_Loudspeakers
```
若为空则模块未运行，可以考虑手动启动
```
sh /data/adb/modules/Automatic_balancing_of_Dual_Loudspeakers/service.sh > /dev/null 2>&1 &
```
终端输入
```
su
echo $(cat/data/Automatic_balancing_of_Dual_Loudspeakers.conf)
```
若无值则未读取到偏移值，可能原因为
1. setlinux限制无法读取
2. 模块未运行

## 其他问题

若上述情况均排除，可以尝试自行解决，开发者已进入高考复习阶段。

# 悲报

目前发现Magsik和kernelSU的busybox不支持某些语法(想知道的自己测试)，一律手动启动吧。至于如何手动，想必读者读到这里已心中有数，我也不一一赘述了。不会的就期待有缘人pull吧(●￣(ｴ)￣●)。