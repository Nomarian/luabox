#!/usr/bin/env lua

function usage()
 print("test file [files] && files exist || files do not exist")
 os.exit(1)
end

-- returns true/false if file is readable/exists
function test(file)
 local f = io.open(file)
 if f then
  io.close(f)
  return true
 end
 return false
end

if #arg==0 then usage() else
 local r = 0
 for i,v in ipairs(arg) do
  if not test(v) then
   r=1
   break
  end
 end
 os.exit(r)
end
