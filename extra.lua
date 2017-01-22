function catfile(name)
if file.open(name,"r") then
  while true do
    local line=file.readline()
    if (line==nil) then file.close() break end
    print(line)
  end
end
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
