_,BoRe=node.bootreason()


wifi.setcountry({country="CA", start_ch=1, end_ch=13, policy=wifi.COUNTRY_AUTO})
wifi.setmode(wifi.STATION,true)


GPIO0  = 3 -- button
GPIO_relais = 6 -- relay (active high)
GPIO_led = 7 -- GREEN LED (active low)
version=0x02


gpio.mode(GPIO0,gpio.INT)
gpio.mode(GPIO_relais,gpio.OUTPUT)
gpio.mode(GPIO_led,gpio.OUTPUT)
gpio.write(GPIO_led,gpio.HIGH)


_G.Bpress=0
_G.MqttStatus=0
_G.config=0

pwm.setup(GPIO_led, 4, 512)
pwm.start(GPIO_led)


function switch(elm)
-- print(gpio.read(elm))
 if (gpio.read(elm)==gpio.HIGH)
 then
    gpio.write(elm,gpio.LOW)
    if _G.MqttStatus==1 then     mqtt:publish(_G.NAME.."/relais","on",0,1) end
 else
    gpio.write(elm,gpio.HIGH)
    if _G.MqttStatus==1 then     mqtt:publish(_G.NAME.."/relais","off",0,1) end
 end
end

function seton()
   elm=GPIO_relais
   gpio.write(elm,gpio.LOW)
   if _G.MqttStatus==1 then     mqtt:publish(_G.NAME.."/relais","on",0,1) end

end

function setoff()
   elm=GPIO_relais
   gpio.write(elm,gpio.HIGH)
   print("set off")
   if _G.MqttStatus==1 then     mqtt:publish(_G.NAME.."/relais","off",0,1) end

end

function getRelais()
      elm=GPIO_relais
      if gpio.read(elm) ==gpio.HIGH
      then
      if _G.MqttStatus==1 then     mqtt:publish(_G.NAME.."/relais","off",0,1) end
      else
      if _G.MqttStatus==1 then     mqtt:publish(_G.NAME.."/relais","off",0,1) end
      end
end


gpio.trig(GPIO0, "both",function(level)
	  local Npress=0
	  if (level==0) then
	    _G.Bpress=tmr.now()
	    pwm.setup(GPIO_led, 3, 500)
	    pwm.start(GPIO_led)
--	    print("press")
	  end

	  if (level==1) then
	    Npress=(tmr.now()-_G.Bpress)/1000
	    pwm.stop(GPIO_led)
	    pwm.close(GPIO_led)
--	    print(Npress)
            gpio.write(GPIO_led,1)
	--    if (Npress>10000) then erase() end
	    if (Npress>50) then switch(GPIO_relais) end
	  end
	end
)

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
 print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\tChannel: "..T.channel)
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
 print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\treason: "..T.reason)
 _G.Gotwifi=0
end)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
 print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
 T.netmask.."\n\tGateway IP: "..T.gateway)
 _G.Gotwifi=1
 do_mqtt_connect()
 dofile('telnet.lc')
 pwm.stop(GPIO_led)
 pwm.close(GPIO_led)
 gpio.write(GPIO_led,1)

end)

if file.exists("conf.lc")
then
 dofile('conf.lc')
 cfg={}
 cfg.ssid=_G.SSID
 cfg.pwd=_G.PASSWIFI
 cfg.save=true
 
 _G.config=1
  wifi.sta.sethostname(_G.NAME)
  wifi.sta.config(cfg)

  mqtt = mqtt.Client(_G.NAME,120)
  mqtt:lwt(_G.NAME.."/relais","off",0,0)


function handle_mqtt_error(client, reason)
  tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function do_mqtt_connect()

 if _G.NAME == nil then
   file.remove('conf.lc')
   node.restart()
 end
print("Config " .. _G.config)
if (_G.config == 1) then 
	 mqtt:connect(_G.MOSQUITO,_G.PORT ,false, function(client)
				   print("connected")
				   client:publish(_G.NAME.."/status","online (".._G.BoRe..")",0,0)
				   client:subscribe({[_G.NAME.."/set"]=0, 
				   		     [_G.NAME.."/countdown"]=0,
						     [_G.NAME.."/reboot"]=0})

				   timesync()
 			          _G.MqttStatus=1
                                  getRelais()
				   end,
				  handle_mqtt_error)
	end
end


mqtt:on("message", function(client, topic, data)
--  print(topic .. ":" )
  if data ~= nil then
--   print(data)

   if topic == _G.NAME.."/set" then switch(GPIO_relais) end
   if topic == _G.NAME.."/countdown" then
   	local _,_,count,action=string.find(data,"([0-9]*);([a-z]*)")
	if (action) then
           val=tonumber(count)*1000
	   client:publish(_G.NAME.."/status","set countdown "..count.." > "..action,0,0)
           if action=="off" then  tmr.create():alarm(val,tmr.ALARM_SINGLE,setoff) end
           if action=="on" then  tmr.create():alarm(val,tmr.ALARM_SINGLE,seton) end
	end

   end

   if topic == _G.NAME.."/reboot" then node.restart() end

  end
end)


function timesync()
sntp.sync('129.6.15.28',
  function(sec,usec,server)
    mqtt:publish(ROOT..NAME.."/status","time set",0,0)
  end,
  function()
     mqtt:publish(ROOT..NAME.."/status","time failed",0,0)
  end
)
end

else

function do_mqtt_connect()
print("err")
end
wifi.sta.clearconfig()

dofile('setup.lc')
print("no conf")
end
