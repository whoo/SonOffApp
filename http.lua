_G.srv=net.createServer(net.TCP,30)
_G.srv:listen(80,function(conn)
  conn:on("receive", function(client,request)
        local buf = "";
        local name="index.html"

        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
        _, _, method, path = string.find(request, "([A-Z]+) /(.*) HTTP");
        end
       print(method)

      if (path == "") then
        name="index.html"
        else
          name=path
        end

        type="file"

        if (name=="get") then
        type=file
        buf="{\"relais\":"..gpio.read(relayPin).."}"
        end

        if (name=="set") then
        end

        if (type=="file") then
        client:send("HTTP/1.0 ".."200 OK\nContent-Encoding: gzip\n\n")
        if file.open(name..".gz","r") then
            buf=file.read(1445)
            file.close()
        else
          buf="HTTP/1.0 404 Not Found"
        end
      end

    --    buf=buf.."\nConnection: close\n\n"
        client:send(buf,function(sk) sk:close()  end)

    end)
end)
