#!/usr/bin/env lua

-- basically tests if args exist in $path
-- doesn't care about permissions

-- returns true/false if file is readable
function test(file)
 local f = io.open(file)
 if f then
  io.close(f)
  return true
 end
 return false
end

-- returns $file/path or nil if not found
function finpathall(file)
 local x
 for i,p in ipairs(path) do
  x = p .. "/" .. file
  if test(x) then print(x) end
 end
end

function finpath(file)
 local x
 for i,p in ipairs(path) do
  x = p .. "/" .. file
  if test(x) then print(x) break end
 end
end


if #arg then
 path = {}
 for p in string.gmatch(os.getenv("PATH"),"[^:]+") do
  path[1+#path] = p
 end
 if arg[1]=="-a" then
  for i=2,#arg do finpathall(arg[i]) end
 else
  for i=1,#arg do finpath(arg[i]) end
 end
end
