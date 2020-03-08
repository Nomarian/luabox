#!/usr/bin/env lua

if #arg==0 then
 io.stderr:write("time prog [args]\n")
 os.exit(0)
end

b=os.time()
args = ""
cmd = arg[1]

if #arg>1 then

 for i=2,#arg do
  args = args .. ' ' .. string.format("%q",arg[i])
 end
 
end

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
