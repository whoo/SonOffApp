if (not file.exists("conf.lc"))
then
--  print("Setup")
  wifi.setmode(wifi.STATIONAP)
  enduser_setup.manual(false)
  print("Start Setup")
  dofile("setup.lc")
else


  -- Variables
  led = 7
  relayPin = 6
  button = 3
  gpio.mode(led, gpio.OUTPUT)
  gpio.mode(relayPin, gpio.OUTPUT)
  gpio.write(led,gpio.HIGH)
  gpio.write(relayPin,gpio.LOW)
  --- start

  if (gpio.read(3)==gpio.LOW)
  then
    print("Reset")
    file.remove("crontab")
    dofile("telnet.lc")
    dofile("file.lc")
  else

    dofile("conf.lc")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID,PASSWIFI)
    wifi.sta.sethostname(NAME)

    dofile("telnet.lc")
    dofile("tools.lc")
    dofile("time.lc")
    dofile("mqtt.lc")
    dofile("file.lc")
    dofile("gpio.lc")

    m = mqtt.Client(NAME,120,"dd","dd")

    ---- Fire after wifi ready()
    tmr.alarm(0,250,tmr.ALARM_AUTO,sblink)
    tmr.alarm(1, 5000, tmr.ALARM_SINGLE, function()
      if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil
      then
        tmr.unregister(0)
        connect()
        timesync()
      end
    end)

  end
end

print("End core")
