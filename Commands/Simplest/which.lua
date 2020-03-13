#!/usr/bin/env lua

function usage()
 print("which file [files] && found ||1 found some ||2 nothing found ||3 this msg")
 print("prints all files found in $path")
 print("NOTE: does not care about permissions") -- BUG
 os.exit(3)
end

-- true if something found else false
function which(file)
 local r = false
 local h -- file handle

  for i,p in ipairs(path) do
   p = p .. "/" .. file
   h = io.open(p)   
   if h then r=true print(p) io.close(h) end
  end

 return r
end

if #arg==0 then usage()
else

 path = {} -- $PATH to path{}
 for p in os.getenv("PATH"):gmatch("[^:]+") do
  path[#path+1] = p
 end

 e=#arg -- exit
 for i=1,#arg do -- maybe cleanname or trim /?
  if which(arg[i]) then e = e - 1 end
 end

 if e>0 then
  if e==#arg then e=2
  else e=1 end
 end

end

os.exit(e)
