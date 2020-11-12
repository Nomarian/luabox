#!/usr/bin/env lua

--[[ TODO
 error if strsize==0 or 1
 UTF8?
]]

strsize = 4
bufsize = 8192

-- debugging functions I'm afraid of taking out
function crasher(a) print(a,"Not done") os.exit(1) end

function inspect( s )
 for x in s:gmatch("%G") do
  io.write( string.format("%s:%s\n", string.byte(x),x ) )
 end
end

-- returns pattern/str with repetitions
function repat(charset,rep) -- lua has no {4} support
 local pat = charset
 for i=2,rep do -- i=2 because pat is defined
  pat = pat .. charset
 end
 return pat
end

function all( f )
 for s in string.gmatch(
  f:read("*a") or "",
  repat("[ -~\t]",strsize) .. "+"
 ) do
  print(s)
 end
end

function buffered( f )
-- Patterns
 local charset = "[ -~\t]"
 local notcharset = "[^ -~\t]"

 -- basically (charset{strsize,})[^charset]
 local pattern = "(" .. repat(charset,strsize) .. "+)" .. notcharset

 local roll -- rollover from last buffer read
 for str in f:lines(bufsize) do

  if roll then
   if string.len(roll) > (bufsize+strsize) then -- roll wont get too big hopefully
    io.write( string.sub(roll,1,bufsize) )
    str = string.sub(roll,bufsize+1) .. str
   else
    str = roll .. str
   end
   roll = nil
  end


-- captured is printable characters, will skip [.\n]$
  for s in string.gmatch(str,pattern) do
   print(s)
  end
  
-- capture skipped part, to be used in the next buffer read as a continuation
  roll = str:match(charset .. "+$")
 end
 
 if roll and
  ( string.len(roll)>strsize )
 then
  print(roll)
 end
 
end

function strings_file( f )
 -- will try to open, get the size, 
 local fsize = f:seek("end")
  f:seek("set")
 if fsize<bufsize then
  io.stderr:write("all\n")
  all( f )
 else
  io.stderr:write("buffered\n")
  buffered( f )
 end
 io.close(f)
end

if #arg==0 then
 buffered(io.stdin) -- can't know size, use strings_buffered
else
 local f
-- TODO: getflags here
 for i,file in ipairs(arg) do
  f = io.open(file, "rb") -- print error for new file?

  if f then
   strings_file(f)
  end -- error if file does not exist?

 end

end

-- its really slow compared to gnu strings, and plan9 strings is slower than gnu
-- but its negligible, when you use it with small binaries (<10mb?)
-- os.execute("ps -C lua u")