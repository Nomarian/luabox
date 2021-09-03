#!/usr/local/bin/lua5.4

local progname = 'ls'
--[[
 TODO
  Get /etc/passwd UID and GID
  convert unixtime to normal time for -l
  -a, -d, -(whatever the opposite of -d is),
  exclude, include

--]]

--[[
 lists files in arg
 if file doesn't exist, prints in stderr no such file or directory
 will list all files in arg, it always prints fullpath or arg
 it supports ORS
 -a, -l, -d
 OFS
--]]

-- so flags work a bit strangely, it behaves like - followed by a character
-- and using a flag more than once, increments a boolean count
flags="lv"

local lfs = require"lfs"

local ORS = os.getenv"ORS" or "\n"
-- arg is file list

if #arg == 0 then arg[1] = "." end

flag = {}

flag.v = 0

function pout(s) io.write(s,ORS) end
function perr(s) io.stderr:write(s,ORS) end

function simple(file)
 if file.mode == "directory" then
  -- no permission to read directory?
  -- not necessary because you already have the table
  x = file.file:find"/$" and "" or "/"
  for f in lfs.dir( file.file ) do
   if f ~= "." and f ~= ".." then
    io.write(file.file .. x .. f .. ORS) 
   end
  end
 else
  io.write(file.file .. ORS)
 end
end

function longlist(file) -- lfs.attributes
 local function oh(s)
  return string.format(
   "%s %s %s %s %s %s\t%s",
   file.permissions,file.nlink,file.uid,file.gid,file.size,file.change,s
  )
 end

 if file.mode == "directory" then
  -- no permission to read directory?
  -- not necessary because you already have the table
  x = file.file:find"/$" and "" or "/"
  for f in lfs.dir( file.file ) do
   if f ~= "." and f ~= ".." then
   pout( oh(file.file .. x .. f) )
   end
  end
 else
  pout( oh(file.file) )
 end

end

do -- flag shit
 for i in flags:gmatch"." do flag[i] = 0 end -- initialize flags to 0

 local pat = "^-([" .. flags .. "])$"
 local pseudoarg = arg
 arg = {}
 
 local x = ""
 for i,e in ipairs(pseudoarg) do
  if e:find(pat) then
   x = e:match(pat)
   flag[ x ] = flag[x] + 1
   --verbosity("flag " .. x .. " = " .. flag[x],2)
   -- used to check out flags, not necessary anymore
  else
   arg[#arg+1] = e
  end
 end
end

local lister = flag.l>0 and longlist or simple

function verbosity(s,level)
 if flag.v > (level or 0) then pout(s) end
end

-- main loop is broken, does not support permissions
for i,file in ipairs(arg) do
 if flag.v>0 then perr("arg: " .. file) end
 local attr = lfs.attributes(file)
 if attr then
  attr.file = file
  lister(attr)
 else
  io.stderr:write(string.format(
   "%s: %s: No such file or directory%s",
   progname,file,ORS
  ))
 end
end

--[[
 TODO
  output formats!
   csv, $OFS
--]] 
