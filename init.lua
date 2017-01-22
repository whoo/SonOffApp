dofile("conf.lc")
dofile("tools.lc")
dofile("time.lc")

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWIFI)
wifi.sta.sethostname(NAME)

-- Variable
led = 7
relayPin = 6
button = 3

gpio.mode(led, gpio.OUTPUT)
gpio.mode(relayPin, gpio.OUTPUT)

gpio.write(led,gpio.HIGH)
gpio.write(relayPin,gpio.LOW)
dofile("telnet.lc")

function mess(con,topic,data)
  sblink()
  m:publish(NAME.."/status","bzzCom",0,0)
  if (topic=="switch")  then switch(data)
  elseif (topic=="timer") then append(data)
  elseif (topic=="countdown") then countdown(data)
  elseif (topic=="set") then set(relayPin,data)
  elseif (topic=="reboot") then
  m:publish(NAME.."/status","unavailable",0,1)
  node.restart()
  end
end

function subscr()
  m:subscribe({timer=0,switch=0,set=0,reboot=0,countdown=0})
  m:publish(NAME.."/status","available",0,1)
  m:publish(NAME.."/relais","off",0,1)
  m:on("offline",connect)
  m:on("message",mess)
  if (file.exists("crontab")) then
    m:publish(NAME.."/status","load cron",0,0)
    loadCron()
  else
    m:publish(NAME.."/status","No Crontab",0,0)
  end

end

function connect()
  m:connect(MOSQUITO,1883,0,subscr)
end


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
