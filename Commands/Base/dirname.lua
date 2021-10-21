#!/usr/local/bin/lua

local ORS = os.getenv"ORS" or "\n"

for i=1,#arg do
 local d,n = arg[i]:match"(.*)/([^/]*)$"
 if d and n then
  d=(#d*#n==0 and "/" or d)
 elseif d or n then
  d="this is not supposed to happen?"
 else
  d="."
 end
 io.write(d,ORS)
end
