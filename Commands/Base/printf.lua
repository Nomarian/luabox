#!/usr/bin/env lua

if #arg==0 then
 io.stderr:write("format [arguments]\n")
 os.exit()
end

arg[1] = string.gsub(arg[1],[[\n]],"\n")
--arg[1] = string.format("%q",arg[1])

io.write(
 string.format( table.unpack(arg) )
)
