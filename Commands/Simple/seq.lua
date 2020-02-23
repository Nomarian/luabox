#!/home/lan/Run/CUI/lua

start,incr="1","1"
if #arg==0 or #arg>3 then
  print("Usage: [first [[incr]] last") os.exit(1)
 elseif #arg==1 then fin=arg[1]
 elseif #arg==2 then start,fin=arg[1],arg[2]
 else start,incr,fin = table.unpack(arg)
end

if string.find(start .. incr .. fin,"%.") then
 x="%g"
else
 x="%i"
end

start=tonumber(start)
incr=tonumber(incr)
fin=tonumber(fin)

for i=start,fin,incr do
 print(string.format(x,i))
end
