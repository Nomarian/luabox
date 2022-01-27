#!/usr/bin/env lua

local lfs = require"lfs"

local function usage()
  io.stderr:write[[which -a prog [progs]

 options
 
  -a prints all files found in $PATH

 RETURN STATUS
  
  0   if all files found and executable || or this if no args
  1   if all files found, some are non-executable
  2   some files found, all executable
  3   no files found]]
 os.exit(0)
end

local flag = {}
for i,v in ipairs(arg) do
  if v=="-a" then
    flag.a = true
    table.remove(arg,i)
    break
  end
end

if #arg==0 then usage() end

local executablebyuser
do
  local account = require"id" -- this is in Luabox/Libraries/id.lua
  local user = os.getenv"USER" or os.getenv"LOGNAME" or
    os.getenv"HOME":match"[^/]+$" -- last resort, could also touch something and check to see the perms
  
  -- the way that unix permissions works is, you have a file, if you own it
  -- then those are the permissions you should look at, not the other, or the group.
  function executablebyuser(file)
    if not io.open(file) then return false end
  
    local attr = lfs.attributes(file)
    
    -- executable by everone
    if attr.permissions:match"^..x..x..x$" then return true end
    
    -- if you own the file, then only u is used, if you're in the group, then g is used, else o
    if account[user].nuid == attr.uid then
      return attr.permissions:match"^..x"
    elseif account[user].ngid == attr.gid then
      return attr.permissions:match"^.....x"
    else
      return attr.permissions:match"x$"
    end
  end
end

local found = {}
local function counter(file,prog) -- if prog is found, decreases a counter.
  found[prog] = true
  print(file)
  return true
end

for i,prog in ipairs(arg) do
  for directory in os.getenv"PATH":gmatch"([^:]+)" do
    local file = directory .. "/" .. prog
    if executablebyuser(file) and counter(file,prog) and not flag.a then break end
  end
end

local c = #arg
for _ in pairs(found) do c = c-1 end
os.exit( c==0 and 0 or c==#arg and 2 or 1 ) -- all files found is 0, some is 1, none is 2