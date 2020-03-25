#!/usr/bin/env lua

--  TODO maybe -i,-v
-- -r is in Simpler and requires lfs
-- can't implement -r without lfs, that's in Simpler

for i,file in arg do
 os.remove(file)
end
