-- minimal stuff

dofile("conf.lc")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWIFI)
wifi.sta.sethostname(NAME)
dofile("telnet.lc")
dofile("file.lc")
