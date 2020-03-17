#!/usr/bin/env lua

-- todo
-- -h -c

function usage()
 print("du files")
 print("Will output the size of files returned by fseek, does not travel")
 print("a size of -1 means it does not exist")
 os.exit(0) 
end

-- returns true/false if file is readable/exists
function exists(file)
 local f = io.open(file)
 if f then
  io.close(f)
  return true
 end
 return false
end

-- you can't append to a directory, so opening with a determines what it is
function regfile(file)
 local handle = io.open(file,"a")

 if handle then
  io.close(handle)
  return true
 else
  return false
 end

end


function sizeof(file)
 local f = io.open(file)
 if f then
   local size = f:seek("end")
   io.close(f)
   return size -- if its a directory you get a WEIRD size
 else
  return -1
 end

end

if #arg==0 then usage()
else
 for i=1,#arg do
  if exists( arg[i] ) and regfile( arg[i] ) then
   print( sizeof( arg[i] ), arg[i] )
  end
 end
end
