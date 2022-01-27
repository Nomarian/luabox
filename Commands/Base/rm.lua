#!/usr/bin/env lua

local help = [[
 base lua can only remove files, not directories
 it also can't list directory items
 so, only -vhi is supported and only as the first arg
]]

local flag = {}

if arg[1]:match"^%-" then
 local options = arg[1]:sub(2)
 if not options:match"^[hiv]+$" then
	io.stderr:write"Wrong flags\n"
	os.exit(1)
 end
 
 for f in options:gmatch"." do flag[f] = true end

 if flag.h then
  print(help)
  os.exit(0)
 end

 if flag.i then flag.v = true end
 
 table.remove(arg,1)
end

-----

local function interact(file)
 local ask
 repeat
  io.write( ('remove "%s"? (y/n): '):format(file) )
  ask = io.read"l":sub(1,1):lower()
 until ask=="y" or ask=="n"
 return ask=="y"
end

-- -i removes -v
for i,file in ipairs(arg) do
 local delete = true
 if flag.i then delete = interact(file) end
 if delete then
  if os.remove(file) then
   if flag.v then print( "removed " .. file ) end
  else
   print( "failed to remove " .. file )
  end
 end
end
