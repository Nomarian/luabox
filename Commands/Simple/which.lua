#!/usr/bin/env lua

-- Synopsis basically tests if args exist in $path
-- BUG doesn't care about permissions

-- -a returns all files
-- it exits 0 if it finds all args in path
-- exits 1 if it found some
-- exits 2 for no args


-- returns true/false if file is exists
function test(file)
 local f = io.open(file)
 if f then
  io.close(f)
  print(file)
  return true
 end
 return false
end

-- returns true if it finds file in path
function findInPath(file,stop)
 local r = false

 if stop then -- just one file

  for i,p in ipairs(path) do
   p = p .. "/" .. file
   if test(p) then r=true break end
  end

 else

  for i,p in ipairs(path) do
   p = p .. "/" .. file
   if test(p) then r=true end
  end

 end
 return r
end

e=2
if #arg>0 and not (#arg==1 and arg[1]=="-a") then

 path = {} -- $PATH to path{}
 for p in os.getenv("PATH"):gmatch("[^:]+") do
  path[#path+1] = p
 end

 local s,x = 1,true
 if arg[1]=="-a" then
  s=2
  x=false
 end
 
 e=0
 for i=s,#arg do
  if not findInPath(arg[i],x) then e=1 end
 end
end
os.exit(e)

