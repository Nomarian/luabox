#!/usr/bin/env lua

function usage()
 io.stderr:write("time prog [args]\n")
 os.exit(0)
end

b=os.time()

function sanitize(str)
 return str:gsub(
  [[\]],[[\\]]
 ):gsub(
  '"','\\"'
 )
end

args = ""
if #arg==0 then
 usage()
elseif #arg>1 then

 for i=2,#arg do
  args = args .. ' "' .. sanitize(arg[i]) .. '"'
 end
 
end
cmd = arg[1]

e,sig = os.execute(cmd .. args)

OFS="\t"

io.stderr:write(
 "real" .. OFS ..
 string.format("%i",
  os.difftime(os.time(),b)
 )
 .. "\n"
)
os.exit(e)
