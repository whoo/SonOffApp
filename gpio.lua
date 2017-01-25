_G.Bpress=0


gpio.trig(button, "both",function(level)
  local Npress=0
  if (level==0) then
    _G.Bpress=tmr.now()
    tmr.alarm(0,1000,tmr.ALARM_AUTO,blink)
  end

  if (level==1) then
    Npress=(tmr.now()-_G.Bpress)/1000
    tmr.unregister(0)
    
    if (Npress>5000) then erase() end
    if (Npress>50) then switch(relayPin) end
  end
end
)
