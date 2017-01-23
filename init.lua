dofile("conf.lc")
dofile("tools.lc")
dofile("time.lc")

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWIFI)
wifi.sta.sethostname(NAME)

-- Variables
led = 7
relayPin = 6
button = 3

gpio.mode(led, gpio.OUTPUT)
gpio.mode(relayPin, gpio.OUTPUT)

gpio.write(led,gpio.HIGH)
gpio.write(relayPin,gpio.LOW)
dofile("telnet.lc")


--- start

if (gpio.read(3)==gpio.LOW)
then
  print("Reset")
  file.remove("crontab")
else

  gpio.trig(button, "both",function(level)
    local Bpress=0
    if (level==0) then
      Bpress=tmr.now()
      tmr.alarm(0,1000,tmr.ALARM_AUTO,blink)
    end

    if (level==1) then
      Npress=(tmr.now()-Bpress)/1000
      tmr.unregister(0)

      --if (Npress>10000) then startTelnet() end
      if (Npress>10000) then node.restart() end
      if (Npress>50) then switch(relayPin) end
    end
  end
)


_G.m = mqtt.Client("dd",120,"dd","dd")


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

-- dofile("http.lc")
-- m:on("message",mess)
