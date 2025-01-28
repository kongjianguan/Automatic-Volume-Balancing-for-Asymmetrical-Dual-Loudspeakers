#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
const std::string MODNAME = "Automatic_balancing_of_Dual_Loudspeakers";
const std::string MODCONF = "/data/" + MODNAME + ".conf";

void writeLog(const std::string& message) {
    std::ofstream logFile("./log.txt", std::ios::app);
    if (logFile.is_open()) {
        logFile << message << std::endl;
        logFile.close();
    }
}

std::string readConfigValue(const std::string& key) {
    std::ifstream configFile(MODCONF);
    std::string line;
    while (std::getline(configFile, line)) {
        size_t pos = line.find(key);
        if (pos != std::string::npos) {
            return line.substr(pos + key.length());
        }
    }
    return "0.0";
}

bool checkAudioDevice() {
    FILE* pipe = popen("dumpsys audio", "r");
    if (!pipe) return false;

    char buffer[128];
    std::string result = "";
    while (!feof(pipe)) {
        if (fgets(buffer, 128, pipe) != NULL)
            result += buffer;
    }
    pclose(pipe);

    std::string devices[] = {
        "bt_a2dp", "headphone", "headset", "usb_headset",
        "bt_a2dp_hp", "bt_sco_hs", "remote_submix", "ble_headset"
    };

    for (const auto& device : devices) {
        if (result.find("Devices: " + device) != std::string::npos) {
            std::cout<<"Devices:"<<device<<std::endl;
            return true;
        }
    }
    return false;
}

int main() {
    while (access("/sdcard/Android", F_OK) != 0) {
        sleep(1);
    }
    writeLog("启动");

    if (access(MODCONF.c_str(), F_OK) != 0) {
        std::ofstream configFile(MODCONF);
        configFile << "volume_offset=0.0" << std::endl;
        configFile.close();
        chmod(MODCONF.c_str(), 0755);
    }

    chmod(".", 0755);

    float volume_offset = std::stof(readConfigValue("volume_offset="));
    float temp = 0.0;
    float vol = 0.0;

    while (true) {
        if (checkAudioDevice()) {
            system("setenforce 0");
            system(("settings put system master_balance " + std::to_string(vol)).c_str());
        } else {
            system("setenforce 0");
            FILE* pipe = popen("settings get system master_balance", "r");
            if (pipe) {
                char buffer[128];
                if (fgets(buffer, 128, pipe) != NULL) {
                    temp = std::stof(buffer);
                }
                pclose(pipe);
            }

            if (temp != vol) {
                volume_offset = temp;
            } else {
                volume_offset = std::stof(readConfigValue("volume_offset="));
            }

            std::ofstream configFile(MODCONF);
            configFile << "volume_offset=" << volume_offset << std::endl;
            configFile.close();

            system(("settings put system master_balance " + std::to_string(volume_offset)).c_str());
            std::cout << "Now the volume_offset = " << volume_offset << std::endl;
        }
        system("setenforce 1");
        sleep(5);
    }

    return 0;
}