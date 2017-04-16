--- Extra Save Life
function copy(source,destination)
  local src = file.open(source, "r")
  if src then
    local dest = file.open(destination, "w")
    if dest then
      local line
      repeat
        line = src:read()
        if line then
          dest:write(line)
        end
      until line == nil
      dest:close(); dest = nil
    end
    src:close(); dest = nil
  end
end

function catfile(name)
  local src=file.open(name,"r")
  if src then
    while true do
      local line=src:readline()
      if (line==nil) then src:close() break end
      print(" "..line:sub(1,-2))
    end
    src = nil
  end
end

function fbase64(name)
  local src=file.open(name,"r")
  local buf=nil
  if src then
    buf = encoder.toBase64(src:read())
    src:close()
    src=nil
  end
  return buf
end


function appendf(name,data)
  file.open(name,"a")
  file.writeline(data)
  file.close()
end

function ls()
  local l = file.list();
  for k,v in pairs(l) do
    print("name:"..k..", size:"..v)
  end
end


function save64(name)
src=file.open("temp.64","r")
dst=file.open(name,"w")
buf=src:read(2048)
dst:write(encoder.fromBase64(buf))
dst:close()
src:close()
end
