#!/usr/bin/env lua

-- [stdin |] wc.lua [files]
-- no -w or -l or -c, just use cut or something

function getchars(v) return #v end
function getlines(v)
 local v,i = string.gsub(v,"\n","")
 return i
end
function getwords(v)
 local v,i = string.gsub(v,"%g+","")
 return i
end

-- TODO
 -- buffer?
  
if 0==#arg then
  local x = io.stdin:read("*a")
  print(getlines(x),getwords(x),getchars(x))
  
else
 for i,v in ipairs(arg) do
  local f = io.open(v)
  if f then
   local x = f:read("*a")
   print(getlines(x),getwords(x),getchars(x),v)
   io.close(f)
  end
 end
end

