
local account = {}
local pat = string.rep("([^:]*):", 7):gsub(":$","",1)
local lines = {}
for line in io.lines"/etc/passwd" do
	local login, pass, uid, gid, comment, home, shell = line:match(pat)
	nuid, ngid = tonumber(uid), tonumber(gid)
	local t = {
		login=login, pass=pass, comment=comment, home=home, shell=shell,
		uid=uid, gid=gid, [nuid] = nuid, [ngid]=ngid, -- uid is text
		group={}, groups={}, gids={}
	}
	account[login], account[uid], account[nuid] = t, t, t
end

-- this asks, is user in this group
-- account.user.group.root -- t/f, 
-- account.user.group[0] -- t/f
for line in io.lines"/etc/group" do
	local t = {line:match"([^:]+):([^:]+):([^:]+):([^:]*)"}
	for m in t[4]:gmatch"[^,]+" do -- matches the groups

		table.insert( account[ m ].groups, t[1])
		table.insert( account[ m ].gids, t[3])
		table.insert( account[ m ].gids, tonumber(t[3]) )

		account[ m ].group[ t[1] ] = true -- name
		account[ m ].group[ t[3] ] = true -- "number"
		account[ m ].group[ tonumber(t[3]) ] = true -- number
	end
end
-- account[user or uid].group[y] == true | false -- is user or uid in group y?

return account
