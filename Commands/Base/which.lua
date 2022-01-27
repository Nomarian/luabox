#!/usr/bin/env lua

if #arg==0 then
 print[[which prog [progs]
 
  prints all files found in $PATH
  exit 0 if files found
  exit 1 if no files found
  exit 2 is this message

  NOTE: does not care about permissions
 ]]
 os.exit(3)
end

-- returns true/false if file is readable by user/exists
local function exists(file)
 local f = io.open(file)
 return f and io.close(f)
end

local count = 1

for directory in os.getenv"PATH":gmatch"([^:]+)" do
 for i,prog in ipairs(arg) do
  local file = directory .. "/" .. prog
  if exists(file) then print(file) count = 0 end
 end
end

os.exit(count)