#!/usr/local/bin/lua

--[[
 Walk is a command that behaves like find, except its much more barebones
 if no arg, then ./ else arg/ 
 -0 is for \0

 Environs
	ORS is also supported
--]]

local lfs = require"lfs"
local progname = 'walk'
ORS = os.getenv"ORS" or "\n"
if arg[1] == "-0" then ORS="\000" table.remove(arg,1) end
if #arg == 0 then arg[1] = "." end

local id = { user = os.getenv"USER" }
do -- get gid and uid
 local f = io.open"/etc/passwd"
 for line in f:lines() do
  local field,i = {},1
  for fi in line:gmatch"[^:]+" do field[i],i = fi,i+1 end
  if field[1] == id.user then id.uid = field[3] id.gid = field[4] break end
 end
 f:close()
end

-- should only be used for directories
local function checkperms(attr) -- permission to read/execute directory
 return 
  (attr.uid == id.uid and attr.permissions:match"^r.x") or
  (attr.gid == id.gid and attr.permissions:match"^...r.x") or
  (attr.permissions:match"r.x$")
end

local function balk(file)
 local attr,err = lfs.attributes(file) -- broken symbolic links files lead to err
 if err then io.stderr:write(err .. "\n") return false end
 io.write(file .. ORS)
 return attr.mode == "directory" and checkperms(attr)
end

local function walk (path) -- must be a directory
    for file in lfs.dir(path) do -- gets all the files in path
    	if file ~= "." and file ~= ".." then
	        file = path .. (path:match"/$" and "" or "/") .. file
    	    if balk(file) then walk(file) end
    	end
    end
end

for i,arr in ipairs(arg) do
 if balk(arr) then walk(arr) end
end
