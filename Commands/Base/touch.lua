#!/usr/bin/env lua

function usage()
 print("touch.lua [files] && created/read files || a nonexistant directory")
 print("if a file does not exist, it will create it")
 os.exit(0)
end

function touch(file)
 local f = io.open(file)
 if not f then
  if file:find("/$") then
   print(file, "cannot create directories")
   os.exit(1)
  end
 
  -- maybe no close for pipes?
  f = io.open(file,"w")
 end
 io.close(f)
end

if #arg==0 then usage() else
 for i,file in ipairs(arg) do touch(file) end
end
