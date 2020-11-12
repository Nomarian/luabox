#!/usr/bin/env lua

bufsize = 8192

function usage()
 print" | rev [files]"
 print "Reverses input"
 os.exit(0)
end

buffered = {}

-- the slow functions go char by char and use different loop styles

-- one loop to rule them all
-- will iterate one by one and seek backwards on a loop
function buffered.slowest(f) -- f is filehandle
 f:seek"end"
 while f:seek("cur",-1) do
  io.write( f:read(1) )
  f:seek("cur",-1)
 end
end


-- will iterate one by one and seek backwards on a loop
function buffered.slower(f)
 f:seek"end"
 f:seek("cur",-1) -- read by 1, 
 io.write( f:read(1) or "")
 while f:seek("cur",-2) do
  io.write( f:read(1) )
 end
end

-- uses bufsize
function buffered.slow(f)
 local size = f:seek"end"
 local negbufsize = bufsize - bufsize * 2
 f:seek("cur",negbufsize)
 io.write( string.reverse( f:read(bufsize) or "" ) )
 negbufsize = negbufsize * 2
 while f:seek("cur",negbufsize) do
  io.write( string.reverse( f:read(bufsize) ) )
 end
 local i = f:seek()
 if i>0 then
  f:seek("set")
  io.write( string.reverse( f:read(i) ) )
 end
end

-- could use coroutines to make it faster?

-- streams cannot use fseek"end"
-- faster uses "l" is a mix between bufsize
-- streams are hard!
-- options
-- put it all in a tmpfile and then use medium()?
-- put it all in a buffer, if buffer exceeds a size, use tmpfile

-- most correct, doesn't care about memory
function stream(handle)
 io.write(
  string.reverse(
   handle:read("*a")
  )
 )
end

if #arg==0 then
 stream(io.stdin)
else
 local f
 for i,file in ipairs(arg) do
   f = io.open(file)
   if f then buffered.slow(f) end
 end
end
