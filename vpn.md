# How to establish a private vpn

1. Install and Configure vpn server. I choice [**shadowsocks**](http://shadowsocks.org).

		wget --no-check-certificate -O shadowsocks.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
		chmod +x shadowsocks.sh
		./shadowsocks.sh 2>&1 | tee shadowsocks.log
		chkconfig shadowsocks on
		systemctl start shadowsocks

	The shadowsocks's config is **/etc/shadowsocks.json**, if you change it, Please restart the shadowsocks service to make it effective.

2. Install vpn client.
	* MacOS: [**ShadowsocksX-NG**](https://github.com/shadowsocks/ShadowsocksX-NG)
	* Windows: [**shadowsocks-windows**](https://github.com/shadowsocks/shadowsocks-windows/releases)
	* Linux: [**shadowsocks-qt5**](https://github.com/shadowsocks/shadowsocks-qt5/wiki/Installation)
	* Android: [**shadowsocks-android**](https://play.google.com/store/apps/details?id=com.github.shadowsocks)
	* IOS: [**shadowRocket-Wingy**](https://www.apple.com/cn/ios/app-store)
