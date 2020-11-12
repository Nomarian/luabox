#!/usr/bin/env lua

function usage()
 print("Usage: clear")
 print("Description: prints esc[Hesc[J to clear the terminal")
 os.exit(0)
end

function clear()
 local esc = "\027"
 local term = os.getenv("TERM")
 if term then
  io.write( esc,"[H",esc,"[2J" )
 else
  print("No $TERM found")
  os.exit(1)
 end

end

if #arg==0 then
 clear()
else
 usage()
end
