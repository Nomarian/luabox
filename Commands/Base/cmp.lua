#!/usr/bin/env lua

function usage()
 print("cmp files && files are equal || not equal")
 os.exit(0)
end

-- returns true if its the same size
function sizecheck(files)
 local size = files[1]:seek("end")
  files[1]:seek("set")
 local i,x = 2,#files
 repeat
  if size == files[i]:seek("end") then
   files[i]:seek("set")
   i = i + 1
  else
   return false
  end
 until i > x
 return true
end

-- returns true if its the same bytes
function bytecheck(files)
 local rsize = 8192

-- advance input on all files at the same time and compare them all
 for str in files[1]:lines(rsize) do
  for i=2,#files do
   if str ~= files[i]:read(rsize) then return false end
  end
 end

-- EOF check unnecessary because they are all the same size

 return true
end

-- files are already open, errors about the file are done in argcheck
if #arg<2 then
 usage()
else
 local filehandles = {}
 for i,file in ipairs(arg) do
 
  local f = io.open(file)
  if f then
   filehandles[#filehandles + 1] = f
  else
   io.stderr:write("Could not open " .. file .. "\n")
   os.exit(1)
  end
  
 end

 if
  sizecheck(filehandles) and bytecheck(filehandles)
 then os.exit(0) else os.exit(1) end
 
end
