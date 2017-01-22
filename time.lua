-- sync time with nist
function timesync()
sntp.sync('129.6.15.28',
  function(sec,usec,server)
    m:publish(NAME.."/status","time set",0,0)
  end,
  function()
     m:publish(NAME.."/status","time failed",0,0)
  end
)
end

function time()
  local tm
  tm = rtctime.epoch2cal(rtctime.get())
  print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end
