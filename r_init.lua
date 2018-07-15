dofile("tools.lc")
dofile("gpio.lc")

if (not file.exists("conf.lc"))
then
  print("Setup")
-- wifi.setmode(wifi.STATIONAP)
  print("Start Setup")
  enduser_setup.start()
  enduser_setup.stop()
  dofile("setup.lc")
  gpio.mode(led, gpio.OUTPUT)
  gpio.write(led,gpio.LOW)

else
  -- Variables
  gpio.mode(led, gpio.OUTPUT)
  gpio.mode(relayPin, gpio.OUTPUT)
  gpio.write(led,gpio.HIGH)
  gpio.write(relayPin,gpio.LOW)
  --- start

  if (gpio.read(3)==gpio.LOW)
  then
    print("Reset")
    file.remove("crontab")
    --  dofile("telnet.lc")
    dofile("file.lc")
  else

    dofile("conf.lc")
    wifi.setmode(wifi.STATION)
    cc={}
    cc.ssid=SSID
    cc.pwd=PASSWIFI
    wifi.sta.sethostname( NAME )
    wifi.sta.config(cc)

--    dofile("telnet.lc")
    dofile("time.lc")
    dofile("mqtt.lc")
    dofile("file.lc")

    m = mqtt.Client( NAME ,120,_G.USER,_G.PASS)

    ---- Fire after wifi ready()
    tmr.alarm(0,250,tmr.ALARM_AUTO,sblink)
    tmr.alarm(1, 5000, tmr.ALARM_AUTO, function()
      if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil
      then
        tmr.unregister(0)
        tmr.unregister(1)
        connect()
        timesync()
	print("[Got an Ip "..wifi.sta.getip().." :D]")
--	else
--	print("restart due to error")
--	tmr.alarm(0,10000,tmr.ALARM_SINGLE, function() node.restart() end)

      end
    end)

  end

dofile("test.lc")
end

print("End Main")
