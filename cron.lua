-- Return function on/off
function getfn(action)
  if (action=="off")  then
    return setoff
  else
    return seton
  end
end

function setoff() set(relayPin,"0") end
function seton() set(relayPin,"1") end

function loadCron()
  local line=nil

  if (file.open("crontab","r")) then
    while true do
      line=file.readline()
      if (line==nil) then
        file.close()
        break
      end
      local tmp,tmp,crontime,action=string.find(line,"(.*);(.*)\n")
      --  cron.schedule(cron,getfn(action))
--      print("set cron "..crontime.."*"..action)
      cron.schedule(crontime,getfn(action))
    end
  end
end
