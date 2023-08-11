# 非对称双扬自动平衡
# Automatic Volume Balancing for Asymmetrical Dual Loudspeakers

该模块通过识别蓝牙音频状态自动调整Android11+的音量平衡偏移值

This module automatically adjusts the offset of the volume balance feature added in Android 11 and above by recognizing the Bluetooth audio status

模块刷入后只需要在蓝牙音频切断的情况下调整音量平衡的参数，脚本就会自动写入配置，重启后也无需再次调参

After the module is flashed, you only need to adjust the volume balance parameters if the Bluetooth audio is cut off, and the script will automatically write the configuration without adjusting the offset again after reboot