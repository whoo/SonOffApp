function checkwifi()
	blink()
	if wifi.sta.status() ~= 5
	then
		print("restart wifi")
		node.restart()
	end
end


-- mytimer = tmr.create()
-- print(mytimer:state())
-- mytimer:register(60*1000, tmr.ALARM_AUTO, checkwifi )
-- mytimer:start()
--
--
--
function urgence()
blink()
mytimer = tmr.create()
mytimer:register(60*1000, tmr.ALARM_AUTO, function() node.restart() end)
mytimer:start()
end


wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, urgence)
