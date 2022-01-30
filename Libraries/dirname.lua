
-- returns the directory name of file,
--[[
function dirname(file)
 local s = file
 local d,n = s:match"(.*)/([^/]*)$"
 if d and n then
  d=(#d*#n==0 and "/" or d)
 elseif d or n then
  error"this is not supposed to happen?"
 else
  d="."
 end
 return d
end
]]

local parseFilename = require "parseFilename"
return function(file)
 return parseFilename(file).directory
end
