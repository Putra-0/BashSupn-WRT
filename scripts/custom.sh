#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Add official OpenClash source
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash

# Add qtools (Tools modems based on the Qualcomm chipset)
svn co https://github.com/koshev-msk/modemfeed/trunk/packages/telephony/qtools koshev-msk/qtools

# Add the default password for the 'root' user (Change the empty password to 'password')
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Set timezone
sed -i -e "s/CST-8/WIB-7/g" -e "s/Asia/Jakarta/g" package/emortal/default-settings/files/99-default-settings-chinese

# Add date version
export DATE_VERSION=$(date -d "$(rdate -n -4 -p pool.ntp.org)" +'%Y-%m-%d')
sed -i "s/%C/%C (${DATE_VERSION})/g" package/base-files/files/etc/openwrt_release

pushd package/base-files
sed -i 's/ImmortalWrt/BashSupn-WRT/g' image-config.in
sed -i 's/ImmortalWrt/BashSupn-WRT/g' files/bin/config_generate
sed -i 's/UTC/WIB-7/g' files/bin/config_generate
popd

sed -i 's/ImmortalWrt/BashSupn-WRT/g' config/Config-images.in
sed -i 's/ImmortalWrt/BashSupn-WRT/g' include/version.mk
sed -i 's/immortalwrt.org/bashsupn.my.id/g' include/version.mk
sed -i 's|github.com/immortalwrt/immortalwrt/issues|bashsupn.my.id|g' include/version.mk
sed -i 's|github.com/immortalwrt/immortalwrt/discussions||g' include/version.mk

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Rename hostname OpenWrt
pushd package/base-files/files/bin
sed -i 's/ImmortalWrt/BashSupn-Wrt/g' config_generate
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Add Argon theme configuration
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon

# Add luci-app-tinyfilemanager
#svn co https://github.com/lynxnexy/luci-app-tinyfilemanager/trunk package/luci-app-tinyfilemanager
#svn co https://github.com/helmiau/helmiwrt-packages/trunk/luci-app-tinyfm package/luci-app-tinyfm

#svn co https://github.com/helmiau/helmiwrt-packages/trunk/badvpn package/badvpn
#svn co https://github.com/helmiau/helmiwrt-packages/trunk/corkscrew package/corkscrew

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/openwrt-openclash
pushd package/openwrt-openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd
