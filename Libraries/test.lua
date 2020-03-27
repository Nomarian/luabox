
-- returns true/false if file is readable/exists
function exists(file)
 local f = io.open(file)
 if f then
  io.close(f)
  return true
 end
 return false
end
