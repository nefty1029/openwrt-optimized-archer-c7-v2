This build uses the same configuration with less patches but with the 4.14 kernel instead of 4.9 using [this pull request](https://github.com/openwrt/openwrt/pull/1013) by jollaman999.

References to "linux/mtd/nand.h" replaced with "linux/mtd/rawnand.h" by:

    find target/linux/ar71xx -type f -print0 | xargs -0 sed -i 's@linux/mtd/nand.h@linux/mtd/rawnand.h@g'

The main difference is the use of flow offload instead of SFE. To enable, select "Software flow offloading" in luci under firewall general or add `option flow_offloading 1` to firewall config under defaults.
