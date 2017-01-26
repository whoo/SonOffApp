function apwifi(t) print("wifi ready") _G.ap=t end
wifi.sta.getap(apwifi)


_G.srv:listen(80,function(conn)
  conn:on("receive", function(client,request)
    local buf = "";
    local name="index.html"

    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
    if(method == nil)then
      _, _, method, path = string.find(request, "([A-Z]+) /(.*) HTTP");
    end

    buf="HTTP/1.0 ".."200 OK\n\n"
    zip="HTTP/1.0 ".."200 OK\nContent-Encoding: gzip\n\n"

    if (path == "") then
      path="index.html"
      if (not file.exists("conf.lc")) then path="setup" end
    end



if (path=="setup")             then if file.open("setup.html.gz","r") then buf=zip..file.read() file.close() end
elseif (path=="wifi")       then for a in pairs(_G.ap) do buf=buf..a.."\n" end
elseif (path=="index.html")   then if file.open(name..".gz","r") then buf=zip..file.read(2048) file.close() end
elseif (path=="jquery.mobile-1.4.5.min.css") then if file.open(name..".gz","r") then buf=zip..file.read(2048) file.close() end
elseif (path=="jquery-1.11.1.min.js") then if file.open(name..".gz","r") then buf=zip..file.read(2048) file.close() end
elseif (path=="jquery.mobile-1.4.5.min.js") then if file.open(name..".gz","r") then buf=zip..file.read(2048) file.close() end
elseif (path=="/push")       then

  if (vars ~= nil)then
    file.open("conf.lua","w")
    for k, v in string.gmatch(vars, "(%w+)=([A-Za-z0-9\.-]+)&*") do

      file.writeline("_G."..k.."=\""..v.."\"")
    end
    file.close()
    node.compile("conf.lua")
    tmr.alarm(1, 5000, tmr.ALARM_SINGLE, function()
      node.restart()
    end)
  end
end

client:send(buf,function(sk) sk:close()  end)

end)
end)
