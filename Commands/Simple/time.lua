#!/usr/bin/env lua

b=os.time()

function usage()
 print("time prog [args]")
end

if #arg==0 then
 usage()
elseif #arg>1 then

 args = ""
 for i=2,#arg do
  args = args .. '"' .. arg[i] .. '" '
 end
 args = string.sub(args,1,#args-1)
 
end
cmd = arg[1]

os.execute(cmd .. " " .. args)

OFS="\t"

io.stderr:write(
 "real" .. OFS ..
 string.format("%i",
  os.difftime(os.time(),b)
 )
 .. "\n"
)
