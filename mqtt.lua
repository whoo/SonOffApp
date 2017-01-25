function mess(con,topic,data)
  sblink()
  m:publish(NAME.."/status","bzzCom",0,0)
  if (topic==NAME.."/switch")  then switch(data)
  elseif (topic==NAME.."/timer") then append(data)
  elseif (topic==NAME.."/countdown") then countdown(data)
  elseif (topic==NAME.."/set") then set(relayPin,data)
  elseif (topic==NAME.."/telnet") then
        _G.srv:close()
        dofile("http.lc")
  elseif (topic==NAME.."/reboot") then
  m:publish(NAME.."/status","unavailable",0,1)
  node.restart()
  end
end

function subscr()
  m:subscribe(NAME.."/set",0)
  m:subscribe(NAME.."/switch",0)
  m:subscribe(NAME.."/timer",0)
  m:subscribe(NAME.."/reboot",0)
  m:subscribe(NAME.."/countdown",0)
  m:subscribe(NAME.."/telnet",0)
  m:lwt(NAME.."/status","lost in the desert",0,1)
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
