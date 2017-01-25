m:publish(NAME.."/status","http",0,0)

_G.srv:listen(80,function(conn)
  conn:on("receive", function(client,request)
        local buf = "";
        local name="index.html"

        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
        _, _, method, path = string.find(request, "([A-Z]+) /(.*) HTTP");
        end

        buf="HTTP/1.0 ".."200 OK\nContent-Encoding: text/html\n\n"


        if (path == "") then
          name="index.html"
        else
          name=path
        end

        if (path=="wifi") then
          for a in pairs(ap) do buf=buf..a.."\n" end
        end

        if (path=="push") then
          print("vars")
        end

        type="file"
        if (type=="file") then
        if file.open(name,"r") then
            buf=buf..file.read()
            file.close()
        else
          buf="HTTP/1.0 404 Not Found"
        end
      end
        client:send(buf,function(sk) sk:close()  end)

    end)
end)
