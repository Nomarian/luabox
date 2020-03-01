#!/usr/bin/env lua

function usage()
 io.stderr:write("time prog [args]\n")
 os.exit(0)
end

b=os.time()

args = ""
if #arg==0 then
 usage()
elseif #arg>1 then

 for i=2,#arg do
  args = args .. ' ' .. string.format("%q",arg[i])
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
