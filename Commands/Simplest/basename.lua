#!/usr/bin/env lua

function usage()
 print("basename [-s suffix] file [files]")
 os.exit(0)
end

do
 if #arg==0 then usage() end
 local c = 0
 if arg[1]=="-s" then
  local x
  
  for i=3,#arg do
   arg[i] = arg[i]:match("[^/]+$") or ""
   print(
    string.sub(arg[i],1, -1 +
     (string.find(arg[i],arg[2],1,true) or 0)
    )
   )
  end
  
 else
  for i=1,#arg do print( arg[i]:match("[^/]+$") or "" ) end
 end
 
end

