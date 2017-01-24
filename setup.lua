
print("Start")

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




-- enduser_setup.manual(false)
enduser_setup.start(
    function()


        file.open("conf.lua","w")
        file.writeline("_G.SSID=\""..wifi.sta.getapinfo()[1].ssid.."\"")
        file.writeline("_G.PASSWIFI=\""..wifi.sta.getapinfo()[1].pwd.."\"")
        file.writeline("_G.NAME=\"sonoff\"")
        file.writeline("_G.MOSQUITO=\"192.168.2.30\"")


        file.close()
        node.compile("conf.lua")
        end,
    function(err, str)
        print("err"..err)
    end
)

print("started")
