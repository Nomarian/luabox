#!/usr/local/bin/lua

--[[
 Walk is a command that behaves like find, except its much more barebones
 if no arg, then ./ else arg/ 
 -0 is for \0

 Environs
	ORS is also supported

 TODO
	if file doesn't exist, prints in stderr no such file or directory
	will list all files in arg, it always prints fullpath or arg
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
local function checkperms(file)
 local attr = lfs.attributes(file)
 return (
  (attr.uid == id.uid and attr.permissions:match"^r.x") or
  (attr.gid == id.gid and attr.permissions:match"^...r.x") or
  (attr.permissions:match"r.x$")
 )
end

-- broken symbolic links files dont exist

function walk (path) -- must be a directory
	if not checkperms(path) then io.stderr:write(path .. ORS) return end
    for file in lfs.dir(path) do -- gets all the files in path
        if file ~= "." and file ~= ".." then
            local f = path .. (path:match"/$" and "" or "/") .. file
            local attr,err = lfs.attributes(f)
            if err then io.stderr:write(err .. "\n")
            else 
            	io.write(f .. ORS)
            	if attr.mode == "directory" then walk (f) end
            end
        end
    end
end
-- permission to read/execute directory

for i,arr in ipairs(arg) do
 if lfs.attributes(arr).mode == "file" then
 	io.write(arr .. ORS)
 else
	walk(arr)
 end
end
