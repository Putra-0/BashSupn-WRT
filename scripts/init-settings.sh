#!/bin/bash
#=================================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'

# Disable IPV6 ula prefix
sed -i 's/^[^#].*option ula/#&/' /etc/config/network

#fix php
uci set uhttpd.main.index_page='index.php index.html'
uci set uhttpd.main.interpreter='.php=/usr/bin/php-cgi'

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit

exit 0
