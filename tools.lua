
-- Set count down
function countdown(data)
  local fn=nil
  local _,_,count,action=string.find(data,"([0-9]*);([a-z]*)")
  if (action) then
    count=tonumber(count)*1000
    m:publish(ROOT..NAME.."/status","set timer "..count.." "..action,0,0)
    tmr.create():alarm(count,tmr.ALARM_SINGLE,getfn(action))
  end
end



function set(elm,state)
  local val="off"
  gpio.write(elm,state)
  if (state=="1") then  val="on"  end
  m:publish(ROOT..NAME.."/relais",val,0,1)
end

-- led
function sblink()
  if (gpio.read(led) == 0) then gpio.write(led, gpio.HIGH) end
  gpio.write(led, gpio.LOW)
  tmr.alarm(5, 50, 0, function() gpio.write(led, gpio.HIGH) end)
end

function blink()
  tmr.alarm(4, 25, tmr.ALARM_AUTO, function ()
    if value == true then
      gpio.write(led,gpio.LOW)
    else
      gpio.write(led,gpio.HIGH)
    end
    value = not value
  end)

  tmr.alarm(5,250,tmr.ALARM_SINGLE,function()
    tmr.unregister(4)
    gpio.write(led,gpio.HIGH)
  end)
end

function switch(elm)
  sblink()
  m:publish(ROOT..NAME.."/status","switch",0,1)
  if (gpio.read(elm)==gpio.HIGH)
  then
    gpio.write(elm,gpio.LOW)
    m:publish(ROOT..NAME.."/relais","off",0,1)
  else
    gpio.write(elm,gpio.HIGH)
    m:publish(ROOT..NAME.."/relais","on",0,1)
  end
end


function append(mask)
  file.open("crontab","a")
  file.writeline(mask)
  file.close()
end

function erase()
  print("Erase")
  --wifi.sta.config("1","")
  file.remove("conf.lc")
  file.remove("conf.lua")
  file.remove("crontab")
end


function listap()
  for k,v in pairs(wifi.ap.getdefaultconfig(true)) do
      print("   "..k.." :",v)
  end
end

function gc()
	collectgarbage()
end
