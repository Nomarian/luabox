#!/usr/bin/env lua
-- TODO expression and better usage()

function usage(n) print[[
arg1 [+-=^*%/<>] arg2
]]
os.exit(n or 1)
end

local function expr(s)
	print"NOT IMPLEMENTED"
	os.exit(1)
end

if #arg==2 then
	--if arg[1]=="+" then -- no clue how to do this
	if arg[1]=="length" then
		print(#arg[2])
	else usage(1) end
elseif #arg==3 then
	if arg[1] == "index" then print( string.find(arg[2],
		arg[3]:gsub([=[[$^%%*()+[%]?.\-]]=],"%%%0") -- sanitize
	)	)
	elseif arg[2] == "<=" then	print(arg[1] <= arg[3])
	elseif arg[2] == ">=" then	print(arg[1] >= arg[3])
	elseif arg[2] == "!=" then	print(arg[1] ~= arg[3])
	elseif arg[2] == "+" then	print(arg[1] + arg[3])
	elseif arg[2] == "-" then	print(arg[1] - arg[3])
	elseif arg[2] == "*" then	print(arg[1] * arg[3])
	elseif arg[2] == "%" then	print(arg[1] % arg[3])
	elseif arg[2] == "/" then	print(arg[1] / arg[3])
	elseif arg[2] == "^" then	print(arg[1] ^ arg[3])
	elseif arg[2] == "<" then	print(arg[1] < arg[3])
	elseif arg[2] == "=" then	print(arg[1] == arg[3])
	elseif arg[2] == ">" then	print(arg[1] > arg[3])
	elseif arg[2] == ":" then	print( string.find(arg[1],"^" .. arg[3]) )
	elseif arg[1] == "match" then print( string.find(arg[2],"^" .. arg[3]) )
	end
elseif #arg==4 and arg[1] == "substr" then
	print( string.sub(arg[2],arg[3],arg[4] )
else
	if arg[1] == "(" and arg[#arg] == ")" then
		print(eval(table.concat(arg)))
	else
		usage(1)
	end
end
