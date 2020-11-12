#!/usr/bin/env lua

function usage()
 print("uniq [files]")
 os.exit(0)
end

-- proper way is using hashes

function uniq( f )
 local last = ""

 for line in f:lines() do
  if last ~= line then
   last = line
   print(line)
  end

 end
 io.close(f)
end

if #arg==0 then uniq(io.stdin)
else
 local f

 for i,v in ipairs(arg) do
  f = io.open(v)
  if f then uniq(f) end
 end

end

