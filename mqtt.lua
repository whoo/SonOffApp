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
