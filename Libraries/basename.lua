
-- returns the filename of file,

local parseFilename = require "parseFilename"
return function(file)
 return parseFilename(file).basename
end
