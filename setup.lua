
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

        local a="_G.SSID=\""..wifi.sta.getapinfo()[1].ssi.."\""
        local b="_G.PASSWIFI=\""..wifi.sta.getapinfo()[1].pwd.."\""

        print("Aie"..wifi.sta.getapinfo()[1].ssid)
        print("Aie"..wifi.sta.getapinfo()[1].pwd)
        end,
    function(err, str)
        print("err"..err)
    end
)

print("started")
