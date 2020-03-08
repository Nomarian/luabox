#!/usr/bin/env lua

function usage()
 print("touch.lua [files] && created/read files/directories")
 print("if a file does not exist, it will create it")
 print("if a file does not exist and ends in /, will create a directory")
 os.exit(0)
end

require'lfs'

function touch(file)
 local f = io.open(file)
 if not f then
  if file:find("/$") then
   return lfs.mkdir(file)
  end
 
  -- maybe no close for pipes?
  f = io.open(file,"w")
 end
 io.close(f)
end

if #arg==0 then usage() else
 for i,file in ipairs(arg) do touch(file) end
end
