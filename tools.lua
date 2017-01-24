
-- Set count down
function countdown(data)
local fn=nil
local _,_,count,action=string.find(data,"([0-9]*);([a-z]*)")
if (action) then
  count=tonumber(count)*1000
  m:publish(NAME.."/status","set timer "..count,0,0)
  tmr.create():alarm(count,tmr.ALARM_SINGLE,getfn(action))
  end
end

-- Return function on/off
function getfn(action)
  if (action=="off")  then
      return setoff
    else
      return seton
    end
end



function setoff() set(relayPin,"0") end
function seton() set(relayPin,"1") end

function set(elm,state)
 local val="off"
 gpio.write(elm,state)
 if (state=="1") then  val="on"  end
 m:publish(NAME.."/relais",val,0,1)
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
	if (gpio.read(elm)==gpio.HIGH)
		then
			gpio.write(elm,gpio.LOW)
      m:publish(NAME.."/relais","off",0,1)
		else
			gpio.write(elm,gpio.HIGH)
      m:publish(NAME.."/relais","on",0,1)
		end
end

function loadCron()
  local line=nil

  if (file.open("crontab","r")) then
  while true do
    line=file.readline()
    if (line==nil) then
      file.close()
      break
    end
    local tmp,tmp,crontime,action=string.find(line,"(.*);(.*)\n")
--  cron.schedule(cron,getfn(action))
    print("set cron "..crontime.."*"..action)
    cron.schedule(crontime,getfn(action))
  end
  end
end

function append(mask)
file.open("crontab","a")
file.writeline(mask)
file.close()
end


function erase()
  print("Erase")
  wifi.sta.config("1","")
  file.remove("conf.lc")
end

function listap()
  for k,v in pairs(wifi.sta.getapinfo()) do
    if (type(v)=="table") then
      print(" "..k.." : "..type(v))
      for k,v in pairs(v) do
        print("\t\t"..k.." : "..v)
      end
    else
      print(" "..k.." : "..v)
    end
  end
end
