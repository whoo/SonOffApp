gpio.trig(button, "both",function(level)
  local Bpress=0
  local Npress=0
  if (level==0) then
    Bpress=tmr.now()
    tmr.alarm(0,1000,tmr.ALARM_AUTO,blink)
  end

  if (level==1) then
    Npress=(tmr.now()-Bpress)/1000
    tmr.unregister(0)
    if (Npress>10000) then node.restart() end
    if (Npress>50) then switch(relayPin) end
  end
end
)
