# SonOff APP
*Based on NodeMCU*

![sonoff](https://cdn.itead.cc/media/catalog/product/cache/1/image/400x400/9df78eab33525d08d6e5fb8d27136e95/s/o/sonoff_01.jpg)

## Build NodeMCU
* with your own with docker https://hub.docker.com/r/marcelstoer/nodemcu-build/
D'ont forget to tweak in app/include/user_modules.h.
* with the cloud platform: https://nodemcu-build.com/
* Choose dev mode + cron/mqtt/net/snpi/rtctime


## Flash device
* Wire your device (only USB to avoid frying)
  * Square is Vcc 3.3
  * RX
  * TX
  * GND
  * (GPIO14)

![img](https://i0.wp.com/randomnerdtutorials.com/wp-content/uploads/2016/11/sonoff_gpio-r.jpg?w=750)

* esptool.py write_flash -fm qio 0x00000 kernel.bin
* Push button to enable flash mode when you connect USB plug until flash process starts.

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
