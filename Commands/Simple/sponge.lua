#!/home/lan/Run/CUI/lua
 
-- sponge.lua [tmpfile]
-- soaks up input from a pipe until it reaches EOF
-- and then writes it into stdout

do
 local f = io.tmpfile()
 if f then
  for line in io.input():lines("L") do
   f:write(line)
  end
  f:seek("set",0)
--  f:setvbuf("no")
  for line in f:lines("L") do
   io.write(line)
--   io.flush()
  end
  
 else
  s = io.input():read("a")
  io.write(s)
 end
end
