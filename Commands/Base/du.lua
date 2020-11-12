#!/usr/bin/env lua

-- todo
-- -h -c

function usage()
 print("du files")
 print("Will output the size of files returned by fseek, does not travel")
 print("a size of -1 means it does not exist")
 os.exit(0) 
end

function sizeof(file)
 if file then
   local size = file:seek("end")
   io.close(file)
   return size -- if its a directory you get a WEIRD size
 else
   return -1
 end
end

if #arg==0 then usage()
else
 local f
 for i,file in ipairs(arg) do
  f = io.open(file,"rb")
  print( sizeof( f ), file )
 end
end
