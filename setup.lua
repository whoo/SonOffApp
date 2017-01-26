function erase()
  print("Erase")
  wifi.sta.config("1","")
  file.remove("conf.lc")
end

-- enduser_setup.manual(false)
-- enduser_setup.start(
--     function()
--         file.open("conf.lua","w")
--         file.writeline("_G.SSID=\""..wifi.sta.getapinfo()[1].ssid.."\"")
--         file.writeline("_G.PASSWIFI=\""..wifi.sta.getapinfo()[1].pwd.."\"")
--         file.writeline("_G.NAME=\"sonoff\"")
--         file.writeline("_G.MOSQUITO=\"192.168.2.30\"")
--
--         file.close()
--         node.compile("conf.lua")
--         file.remove("conf.lua")
--         node.restart()
--         end,
--     function(err, str)
--         print("err"..err)
--     end
-- )

_G.ap=nil

wifi.setmode(wifi.STATIONAP)
dhcp_config ={}
dhcp_config.start = "192.168.4.5"
wifi.ap.dhcp.config(dhcp_config)
wifi.ap.dhcp.start()
_G.srv=net.createServer(net.TCP,180)
print("GO")
dofile("http.lc")
