#!/usr/bin/env lua

-- tee.lua [-mode files]
-- saves input to files
-- writes to standard output

function writetofiles(files,str)
 io.write(str)
 for i,f in ipairs(files) do
  f:write(str)
 end
end

do
 local iarg = 1
 local modematch = "[wa]%+?b?"
 local mode = "w"
 if #arg>0 and string.find(arg[1],"^-".. modematch .. "$") then
  iarg = 2
  mode = string.match(arg[1],"^%-(" .. modematch .. ")$")
 end

-- open the files WHEN you get input
 local line = io.input():read("L")
 
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
 
 if not line then os.exit(0) end
 writetofiles(files,line)
 
end

for line in io.input():lines("L") do
 writetofiles(files,line)
end
