#!/usr/bin/env lua5.4

--[[
Synopsis: find
Use: find [options] [path]
Warning:
Bugs:
	ExistsB fails on openbsd, but openbsd is useless anyway.
Requirements: luaposix

TODO:
	-print0 -> changes EOL from \n to \0
	-slash  -> EOL is //
	-json   ->
	-xml    ->
	-ljson  -> line json
	-csv    -> EOL is \n, surrounds with "", escapes are ""
	-tsv    -> EOL is \n, escapes \n with \\n
--]]

------------------------- REQUIRE

local posix = require"posix"

------------------------- ENV

local _G = _G
local env = {} for k,v in pairs(_G) do env[k] = v end
local mt = {
	__index = function (_,k)
		error(
			string.format("Attempted to fetch nonexistent %s from global table",k)
			, 2
		)
	end
	,__newindex = function (t,k,v)
		error(string.format("ERROR: _G[%s]=%s",k,v),2)
	end
}
local _ENV = setmetatable(env, mt)

--------------------- MAIN

local function ExistsB(path)
	return os.rename(path,path)
end

local TraverseRecursive
function TraverseRecursive (path)
	for file in posix.files(path) do
		if file ~= "." and file ~= ".." then
			file = path .. '/' .. file
			print(file)
			if ExistsB(file .. "/.") then
				TraverseRecursive(file)
			end
		end
    end
end

local EqualBehavior
function EqualBehavior (path)
	for file in posix.files(path) do
		if file ~= "." and file ~= ".." then
			file = path .. '/' .. file
			print(file)
			if ExistsB(file .. "/") then
				local B, msg = ExistsB(file .. "/.") -- dir is accessible
				if B then
					EqualBehavior(file)
				else
					io.stderr:write(string.format("find: '%s': %s\n"
						, file
							:gsub("\\","\\\\")
							:gsub("'","\\'")
						,msg
					))
				end
			end
		end
    end
end

local function Traverse (path)
	print(path)
	TraverseRecursive(path)
end


Traverse(arg[1] or ".")
