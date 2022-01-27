#!/usr/local/bin/lua

local pat = string.rep("([^:]*):", 7):gsub(":$","",1)

local lines,account = {}, {}
for line in io.lines"/etc/passwd" do
 local login,pass,uid,gid,comment,home,shell = line:match(pat)
 lines[#lines+1] = { login=login, pass=pass, uid=uid, gid=gid, comment=comment, home=home, shell=shell}
 account[login] = { login=login,pass=pass, uid=uid, gid=gid, comment=comment, home=home, shell=shell}
 account[uid] = { login=login, pass=pass, uid=uid, gid=gid, comment=comment, home=home, shell=shell}
end

local user = arg[1] or os.getenv"USER" or os.getenv"LOGNAME" or os.getenv"HOME":match"([^/]+$"

io.write(string.format(
 "uid=%i(%s) gid=%i(%s) groups=",
  account[user].uid, account[user].login,
  account[user].gid, user
 )
)

local b,i = {}, 1
for line in io.lines"/etc/group" do
 local t = {line:match"([^:]+):([^:]+):([^:]+):([^:]*)"}
 if t[1]~=user and t[4]:find(user,1,true) then
	i,b[i] = i+1, t[3] .. "(" .. t[1] .. ")"
 end
end

print(table.concat(b,","))
