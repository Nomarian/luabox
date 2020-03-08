#!/usr/bin/env lua

if #arg==0 or #arg>3 then
 print("Usage: [first [[incr]] last")
 os.exit(1)
end

format="%i"
for i,v in ipairs(arg) do
 if string.find(v,"%.") then
  format="%g"
 end
 arg[i] = tonumber(arg[i])
end

start,incr=1,1
if #arg==1 then fin=arg[1]
 elseif #arg==2 then start,fin=arg[1],arg[2]
 else start,incr,fin = table.unpack(arg)
end

if format=="%i" then
 for i=start,fin,incr do print(i) end
 os.exit()
end

if -- positive to infinity
  (start>=0 and start<=fin)
 or -- negative to infinity
  (start<=0 and fin<=start)
 or -- positive infinity regression that wont reach 0
  (start>0 and fin>0 and start>fin)
 or -- negative infinity progression that wont reach 0
  (start<0 and fin<0 and start<fin)
then
 format = "%g"
else -- Possible passthrough 0
 format = "%f"
 -- get number of digits after . in incr
 local x1,x2 = string.find(tostring(incr),"%.([0-9]+)")
 format = "%." .. x2-x1.. "f"
end

for i=start,fin,incr do
 print( string.format(format,i) )
end
os.exit()
