#!/usr/bin/env lua

-- tee.lua [-mode files]
-- saves input to files
-- writes to standard output

do
 local iarg = 1
 local modematch = "[wa]%+?b?"
 local mode = "w"
 if #arg>0 and string.find(arg[1],"^-".. modematch .. "$") then
  iarg = 2
  mode = string.match(arg[1],"^%-(" .. modematch .. ")$")
 end

 files = {}
 local f
 for i=iarg,#arg do
  f = io.open(arg[i],mode)
  if f then
  -- f:setvbuf("full") -- maybe?
  -- print(arg[i]) opened file
   files[1+#files] = f
  end
 end
end

for line in io.input():lines("L") do
 io.write(line)
 for i,f in ipairs(files) do
  f:write(line)
  -- f:flush()
 end
end
