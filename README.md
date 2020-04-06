# SonOff APP
*Based on NodeMCU*

![sonoff](https://www.chatteris.biz/blog/wp-content/uploads/2018/01/IMG_2011-Medium-768x1024.jpg)

## Build NodeMCU
* with your own with docker https://hub.docker.com/r/marcelstoer/nodemcu-build/
D'ont forget to tweak in app/include/user_modules.h.
* with the cloud platform: https://nodemcu-build.com/
* Choose dev mode + cron/mqtt/net/snpi/rtctime/encoder/enduser_setup


## Flash device
* Wire your device (only USB to avoid frying)
  * Square is Vcc 3.3
  * RX
  * TX
  * GND
  * (GPIO14)


* Push button to enable flash mode when you connect USB plug until flash process starts.
> esptool.py write_flash -fm qio 0x00000 kernel.bin
> esptool.py write_flash --flash_mode dout -fs 8m 0x0 nodemcu_float_master_20200406-0025.bin

![img](https://i0.wp.com/randomnerdtutorials.com/wp-content/uploads/2016/11/sonoff_gpio-r.jpg?w=750)


## Setup your environnement
(*no friendly setup for now*)
conf.lua

## Upload code
Via [nodemcu-uploader.py](https://github.com/kmpm/nodemcu-uploader) or upload.sh

## Mosquitto / Mqtt
Use private server or public server to manage device

## Docs
* https://www.itead.cc/sonoff-wifi-wireless-switch.html
* https://randomnerdtutorials.com/how-to-flash-a-custom-firmware-to-sonoff/
* https://github.com/espressif/esptool
* https://github.com/kmpm/nodemcu-uploader
