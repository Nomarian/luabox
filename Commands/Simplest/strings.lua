#!/usr/bin/env lua

function strings( f )
 local x = f:read("*a")
-- todo, UTF8 support
 for s in x:gmatch("[%g \t]+") do
  if string.len(s)>3 then print(s) end
 end

end

if #arg==0 then strings(io.stdin)
 else local f

 for i,v in ipairs(arg) do
  f = io.open(v)
  if f then strings(f) io.close(f) end
 end

end

