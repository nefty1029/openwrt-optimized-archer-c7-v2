This is a modified ath79 build of the [firmware](https://github.com/infinitnet/lede-ar71xx-optimized-archer-c7-v2) configured by r00t ([discussion](https://forum.openwrt.org/t/1382)) that includes various patches from [gwlim](https://github.com/gwlim/mips74k-ar71xx-lede-patch).

The package selection and configuration was partially intended for personal use and is overall lighter.
A similar build for the Archer C2600 is available [here](https://github.com/shunjou/openwrt-optimized-archer-c2600).
\
\
Migration from existing ar71xx system requires a forced sysupgrade via ssh¹:
```
cd /tmp
wget https://github.com/shunjou/openwrt-optimized-archer-c7-v2/raw/master/openwrt-ath79-generic-tplink_archer-c7-v2-squashfs-sysupgrade.bin
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
