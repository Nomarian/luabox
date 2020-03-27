
-- returns true if its the same size
function sizecheck(handles)
 local size = handles[1]:seek("end")
  handles[1]:seek("set")
 local i,x = 2,#handles
 repeat
  if size == handles[i]:seek("end") then
   handles[i]:seek("set")
   i = i + 1
  else
   return false
  end
 until i > x
 return true
end

-- returns true if its the same bytes
function bytecheck(handles)
 local rsize = 8192

-- advance input on all handles at the same time and compare them all
 for str in handles[1]:lines(rsize) do
  for i=2,#handles do
   if str ~= handles[i]:read(rsize) then return false end
  end
 end

-- EOF check unnecessary because they are all the same size

 return true
end

function cmp(files)
 local f
 local handles = {}
 for i,file in ipairs(files) do

  f = io.open(file)
  if f then
   handles[#handles + 1] = f
  else
   io.stderr:write("Could not open " .. file .. "\n")
   os.exit(1)
  end
  
 end

 return sizecheck(handles) and bytecheck(handles)
end
