#!/usr/bin/env lua

-- basically looks for $1 in /proc/*/cmdline

if #arg ~= 1 then
 io.stderr:write"Incorrect # of args"
 os.exit(1)
end

require 'lfs'

do
 local f,s
 for d1,d2 in lfs.dir"/proc" do -- gotta use dir_obj:next() ?
  if d1:find"^%d+$" then
   f = io.open("/proc/" .. d1 .. "/cmdline")
   s = f:read"a"
   io.close(f)
   if s:find(arg[1],1,1) then print(d1) end
  end
 end
end