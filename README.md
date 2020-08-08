This is a modified ath79 build based on the [firmware](https://github.com/vurrut/openwrt-optimized-archer-c7-v2) by Vurrut, which is based on the [firmware](https://github.com/shunjou/openwrt-optimized-archer-c7-v2) by shunjou, which is based on the [firmware](https://github.com/infinitnet/lede-ar71xx-optimized-archer-c7-v2) configured by r00t ([Discussion](https://forum.openwrt.org/t/1382) has been closed as of May 20, 2020) that includes various patches from [gwlim](https://github.com/gwlim/mips74k-ar71xx-lede-patch) with a lighter package selection.
\
\
This release will be focused on maintenance. No new packages will be added to maintain the small file size 
and only the existing code and packages will be updated. 
Expect a new release every last week of the month unless there are publicized security vulnerabilities.
\
If you want to add new packages to the firmware, kindly fork this repository and add the packages to your own firmware.
\
\
Migration from existing ar71xx system requires a forced sysupgrade via ssh¹:
```
cd /tmp
wget https://github.com/nefty1029/openwrt-optimized-archer-c7-v2/releases/download/v19.07.3/openwrt-ath79-generic-tplink_archer-c7-v2-squashfs-sysupgrade.bin
sha256sum openwrt-ath79-generic-tplink_archer-c7-v2-squashfs-sysupgrade.bin
sed -i 's#pci0000:01/0000:01:00.0#pci0000:00/0000:00:00.0#g; s#platform/qca955x_wmac#platform/ahb/ahb:apb/18100000.wmac#g' /etc/config/wireless
sysupgrade -F openwrt-ath79-generic-tplink_archer-c7-v2-squashfs-sysupgrade.bin
```
¹ Also possible in luci since [89486bd](https://github.com/openwrt/luci/pull/2075)
\
\
Recommended to make a config backup and use `-n` with sysupgrade to not keep settings after upgrade. If not, then be sure to use the sed command to update the wireless radio paths before flashing to avoid creating duplicate radio entries.
\
\
Issues:
- Ethernet port status LEDs can't be manually controlled
