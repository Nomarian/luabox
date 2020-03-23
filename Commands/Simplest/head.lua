#!/usr/bin/env lua

readbytes = 8192
bytes=0
lines=5

-- flags,arg = getflags("-l lines,-b bytes,-q (quiet)",arg)
-- c will set lines to 0, if you want both -c and -n, use -n after -c

if #arg>0 then
 local i,skip,args = 1, 0, {}
 repeat 
  if arg[i]=="-q" then
   quiet = true
  elseif i+1 <= #arg and arg[i+1]:find("^%d+$") then

 -- arg is flag? is there a second arg? is that arg a digit?
   if arg[i]=="-b" then -- b sets lines to 0
    bytes,lines,skip = tonumber(arg[i+1]), 0, 1
   elseif arg[i]=="-l"then
    lines,skip = tonumber(arg[i+1]),1
   end

  else
   args[#args + 1] = arg[i]
  end

  i = i + 1 + skip
  skip = 0
  
 until i>#arg
 arg = args
end

function head_lines(f)
 local str
 for i=1,lines do
  str = f:read()
  if str then
   print( str )
  else
   break
  end
 end
end

function normalgrab(f)
 local t,p = 0,0 -- total, printed
 for str in f:lines(readbytes) do
  t = t + #str
  if t<bytes then
   io.write(str)
   p = t
  elseif t>bytes then
   io.write( string.sub(str,1, bytes%t) )
   break
  else -- t==bytes
   io.write(str)
   break
  end
 end
end

function head_bytes(f)
 if bytes<=readbytes then
  io.write( f:read(bytes) or "" )
 else
  normalgrab( f )
 end
end

function head_both(f)
 local str,t,p = "",0,0
 for i=1,lines do
  str = f:read("L")
  if str==nil then break end
  t = t + #str
  if t<bytes then 
   io.write(str)
   p = t
  elseif t>bytes then 
   io.write( string.sub(str,1, bytes%t) )
   break
  else
   io.write(str)
   break
  end
 end
end

function head(f) -- the function must close the file on its own
 if bytes>0 and lines>0 then head_both(f)
 elseif lines>0 then head_lines(f)
 elseif bytes>0 then head_bytes(f)
 end
 if f then io.close(f) end -- most times they wont be closed
end

if #arg==0 then
 head(io.stdin)
elseif #arg==1 then
 local f = io.open( arg[1] )
 if f then head(f) end -- error if file does not exist?
else
 local f
 for i,file in ipairs(arg) do
  if not quiet then print("==> " .. file .. " <==") end
  if f then head(f) end -- error if file does not exist?
 end
end

os.exit(0)
