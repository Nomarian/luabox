#!/usr/bin/env lua

-- This version just copies data from one to the other
-- This version reads all the bytes in file1 and writes it to file2

function usage()
 print'cp [+mode] origin-file files'
 print'copies the origin file to files'
 print'modes are [w]rite [a]ppend you can add a b at the end for binary'
 os.exit(0)
end

-- default mode
writemode = 'w'
if arg[1] and arg[1]:find"^%+[wa]%+?b?$" then
-- if there is binary mode or +, readmode will inherit it
 readmode = "r" .. arg[1]:match"%+?b?$"
 writemode = table.remove(arg,1):sub(2)
end

-- todo? if #arg==1 then copy from stdin to file?
-- just use tee? or maybe tee is unnecessary
if #arg<2 then
 usage()
else
 local f = io.open( table.remove(arg,1), readmode )
 if not f then
  print"Could not open Origin File"
  os.exit(1)
 end

 local handles = {}
 for i,file in ipairs(arg) do
  handles[i] = io.open(file,writemode)
 end

 bufsize = 2 ^ 10 -- 10 or 12 or 13?
 for buf in f:lines(bufsize) do -- read once, write all
  for i,h in ipairs(handles) do
   h:write(buf)
  end
 end
 
end
