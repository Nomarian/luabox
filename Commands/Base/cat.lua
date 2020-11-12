#!/usr/bin/env lua

-- bufsize 8192
function cat(file,bufsize)
 if not bufsize then bufsize=8192 end
 local f = io.open(file)
 if not f then return false end
 local buffer
 for buffer in f:lines(bufsize) do
  io.write( buffer )
 end
 io.close(f)
 return true
end

if #arg==0 then
 arg[1]="/dev/stdin"
end

for i,File in ipairs(arg) do
 cat(File)
end
