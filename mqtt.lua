function mess(con,topic,data)
  sblink()
  m:publish(ROOT..NAME.."/status","bzzCom",0,0)
  if (topic==ROOT..NAME.."/switch")  then switch(data)
  elseif (topic==ROOT..NAME.."/timer") then append(data)
  elseif (topic==ROOT..NAME.."/countdown") then countdown(data)
  elseif (topic==ROOT..NAME.."/set") then set(relayPin,data)
  elseif (topic==ROOT..NAME.."/cronlist") then if (data=="erase") then file.remove("crontab") else m:publish(ROOT..NAME.."/crontab",fbase64("crontab"),0,0) end
  elseif (topic==ROOT..NAME.."/http") then
        _G.srv:close()
        dofile("http.lc")
  elseif (topic==ROOT..NAME.."/reboot") then
  m:publish(ROOT..NAME.."/status","unavailable",0,1)
  node.restart()
  end
end


function http()
	_G.srv:close()
	dofile("http.lc")
end

function subscr()
--  print("connect")
  m:subscribe(ROOT..NAME.."/set",0)
  m:subscribe(ROOT..NAME.."/switch",0)
  m:subscribe(ROOT..NAME.."/timer",0)
  m:subscribe(ROOT..NAME.."/reboot",0)
  m:subscribe(ROOT..NAME.."/countdown",0)
  m:subscribe(ROOT..NAME.."/http",0)
  m:subscribe(ROOT..NAME.."/cronlist",0)
--  m:lwt(NAME.."/status","lost in the desert",0,1)
  m:publish(ROOT..NAME.."/status","available",0,1)
  m:publish(ROOT..NAME.."/status","boot",0,0)
  m:publish(ROOT..NAME.."/relais","off",0,1)
  m:on("offline",connect)
  m:on("message",mess)
  if (file.exists("crontab")) then
    m:publish(ROOT..NAME.."/status","load cron",0,0)
    loadCron()
  else
    m:publish(ROOT..NAME.."/status","No Crontab",0,0)
  end

end

function connect()
  m:connect(_G.MOSQUITO,tonumber(_G.PORT),tonumber(_G.SSL),1,subscr)
end
