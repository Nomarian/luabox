#!/usr/bin/env lua

--use string.gsub and add a \n at the end of every string
-- if one is at the end o

-- todo, UTF8 support
strsize = 3
bufsize = 8192

function all( f )
 local str = f:read("*a")
 for s in str:gmatch("[%g \t]+") do -- newlines mess everything
  if string.len(s)>strsize then print(s) end
 end
end

function crasher(a) print(a,"Not done") os.exit(1) end

function buffered( f )
 local roll -- rollover from last buffer read
 for str in f:lines(bufsize) do

  if roll then -- might get full
   if string.find(roll .. str,"[^ -~]") then
    str = roll .. str -- leave the mess to the main loop
   else  -- its a huge string, write everything out
    if string.len(roll)>strsize then
     io.write(roll) -- I am unsure if this makes sense
    end
   end
   roll = nil
  end
  
-- captured is printable characters, will skip [.\n]$
  for s in str:gmatch("([ -~\t]+)[^ -~]") do
   if string.len(s)>strsize then print(s) end
  end
  
-- capture skipped part, to be used in the next buffer read as a continuation
  roll = str:match("[ -~\t]+$") -- a string without newlines will fill roll
 end
 
 if roll and
  ( string.len(roll)>strsize )
 then
  print(roll)
 end
 
end

function inspect( s )
 for x in s:gmatch("%G") do
  io.write( string.format("%s:%s\n", string.byte(x),x ) )
 end
end

function strings_file( f )
 -- will try to open, get the size, 
 local fsize = f:seek("end")
  f:seek("set")
 if fsize<bufsize then
--  io.stderr:write("all\n")
  all( f )
 else -- io.stderr:write("buffered\n")
  buffered( f )
 end
 io.close(f)
end

if #arg==0 then
 buffered(io.stdin) -- can't know size, use strings_buffered
else
 local f

 for i,v in ipairs(arg) do
  f = io.open(v) -- print error for new file?
  if f then strings_file(f) end -- error if file does not exist?
 end

end

--[[

function blah()
 if f then
  for line in io.input():lines("L") do
   f:write(line)
  end
  for line in f:lines("L") do
   io.write(line)
  end
  
 else
  s = io.input():read("a")
  io.write(s)
  end
 end
end

]]

