#!/usr/bin/env lua

-- echo.lua [args]
-- want -n? use printf instead

args=""

if #arg>0 then
 for i=1,#arg-1 do
  args = args .. arg[i] .. ' '
 end
 args=args .. arg[#arg]
end

print(args)
