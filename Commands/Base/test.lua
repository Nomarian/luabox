#!/usr/bin/env lua

-- it depends on permissions, so this will absolutely fail

function usage()
 print("test file [files] && files exist || files do not exist")
 os.exit(1)
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
function dir(file)
 local handle,msg,errno
 if not exists( file ) then return false end
 handle,msg,errno = io.open(file,"a")
 if
  handle == nil
  and
  msg:lower():find( "directory$" ) -- depends on OS?
 then
  return true
 else
  io.close(handle)
  return false
 end
end

-- you can't append to a directory, so opening with a determines what it is
function regfile(file)
 local handle,msg,errno
 if not exists( file ) then return false end
 handle,msg,errno = io.open(file,"a")

 if handle then
  io.close(handle)
  return true
 else
  return false
 end

end

if #arg==0 then usage() else
 local r,fn,s = 0,exists,1

 if arg[1] == "-d" then
  fn,s = dir,2
 elseif arg[1] == "-f" then
  fn,s = regfile,2
 end

 for i=s,#arg do

  if not fn( arg[i] ) then
   r=1 break
  end

 end

 os.exit(r)
end
