# Build
## Clone the source code
```
git clone https://github.com/lmtan91/BBB_PODD_OTA.git
cd BBB_PODD_OTA
./build -c
```
## Modify the wpa_supplicant to the destination WiFi network
Modify **bbb/meta-alencon/recipes-connectivity/wpa-supplicant/files/wpa_supplicant.conf-sane**
```
network={
    key_mgmt=WPA-PSK
    ssid="Pixel_6570"
    psk="12345668"
}
```
## Build the whole firmware
`./build.sh -b`

# Flash eMMC image
sudo mkdir -p /media/card

## Create SDCARD partitions
!!!BECAREFUL, depend on your sdcard device such as sdb or sdc
`sudo ./tools/mk2parts.sh sdX`

### Flash image into sdcard
```
sudo ./tools/copy_boot.sh sdb
sudo ./tools/copy_rootfs.sh sdb installer alencon
sudo ./tools/copy_emmc_install.sh sdb console
```

# Connect to WiFi hotspot
If you have already configure the correct SSID/PSK in the previous step. If not, modifying in the **/etc/wpa_supplicant.conf**. Then just type the command below to connect automatically to the hotspot
`ifup wlan0`

# Start ssh service
`systemctl start sshd`
