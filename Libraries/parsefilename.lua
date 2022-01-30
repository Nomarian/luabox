
return function (file) -- returns { file, directory, filename, extension, basename }
--[[
  file	= directory/filename
  directory	= directory or .
  filename	= basename.extension
  basename	= filename without the last extension
  extension	= filename without the basename 
 --]]

 local t = {
	file=file,
 	directory = file:match".*/" or ".",
 	filename = file:match("[^/]+$") or ""
 }
 t.basename = t.filename:match"(.+)%.[^.]+$" or t.filename
 t.extension = t.filename:match".+%.([^.]+)$" 
 -- t.basename, t.extension = t.filename:match"(.+)%.([^.]+)$" or t.filename
 -- t.hidden = t.extension and t.filename:find"^%."
 return t
end
