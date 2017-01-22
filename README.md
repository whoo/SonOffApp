# SonOff APP
*Based on NodeMCU*


## Build NodeMCU
* with your own with docker https://hub.docker.com/r/marcelstoer/nodemcu-build/
D'ont forget to tweak in app/include/user_modules.h.
* with the cloud platform: https://nodemcu-build.com/
* Choose dev mode + cron/mqtt/net/snpi/rtctime


## Flash device
* Wire your device (only USB to avoid fry)
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
via nodemcu-uploader.py or upload.sh

## Documentations
* https://www.itead.cc/sonoff-wifi-wireless-switch.html
* https://randomnerdtutorials.com/how-to-flash-a-custom-firmware-to-sonoff/
* https://github.com/espressif/esptool
