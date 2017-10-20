
-- http://snippets.luacode.org/?p=snippets/Deep_copy_of_a_Lua_Table_2
table.clone = function(t,deepnum)
	if type(t) ~= 'table' then return t end
	local mt = getmetatable(t)
	local res = {}

	if deepnum and deepnum > 0 then
		deepnum = deepnum - 1
	end
	for k,v in pairs(t) do
		if type(v) == 'table' then
			if not deepnum or deepnum > 0 then
				v = table.clone(v, deepnum)
			end
		end
		res[k] = v
	end
	setmetatable(res,mt)
	return res
end

table.len = function(tbl)
	if type(tbl) ~= "table" then return 0 end
	local n = 0
	for k,v in pairs(tbl) do n = n + 1 end
	return n
end

table.tostring = function(data, _indent)
	local visited = {}
	local function dump(data, prefix)
		local str = tostring(data)
		if table.find(visited, data) ~= nil then return str end
		table.insert(visited, data)

		local prefix_next = prefix .. "  "
		str = str .. "\n" .. prefix .. "{"
		for k,v in pairs(data) do
			if type(k) == "number" then
				str = str .. "\n" .. prefix_next .. "[" .. tostring(k) .. "] = "
			else
				str = str .. "\n" .. prefix_next .. tostring(k) .. " = "
			end
			if type(v) == "table" then
				str = str .. dump(v, prefix_next)
			elseif type(v) == "string" then
				str = str .. '"' .. v .. '"'
			else
				str = str .. tostring(v)
			end
		end
		str = str .. "\n" .. prefix .. "}"
		return str
	end
	return dump(data, _indent or "")
end

table.find = function(this, value)
	for k,v in pairs(this) do
		if v == value then return k end
	end
end

--[[
-- 全排列
-- 参数：t 		- 全排列的数组
		 r 		- {}

-- 结果：r 得到 n 种排列结果
-- eg: 	local tbl = {1, 3, 4, 6, 2}
		local ret = {}
		table.fPermutation(tbl, ret)
--]]
table.fPermutation = function(t, r, tlen)
	local tlen = tlen or #t
	if tlen == 0 then
		table.insert(r, table.clone(t))
	else
		for i=1,tlen do
			t[tlen], t[i] = t[i], t[tlen]
			table.fPermutation(t, r, tlen - 1)
			t[tlen], t[i] = t[i], t[tlen]
		end
	end
end

--[[
-- 排列组合
-- 参数：t 		- 做排列组合的数组
		 cNum 	- 每个组合的个数
		 r 		- {}
		 index 	- 得到其中一种组合
		 begin 	- 取值的下标
-- 结果：在 tlen 个中取 cNum 个得到n种结果缓存在 r
-- eg: 	local tbl = {1, 3, 4, 6, 2}
		local ret = {}
		table.cPermutation(tbl, 3, ret)
--]]
table.cPermutation = function(t, cNum, r, index, begin)
	local index = index or {}
	local begin = begin or 1
	for i=begin,#t - cNum + 1 do
		index[cNum] = i
		if cNum == 1 then
			local r_son = {}
			for _,v in ipairs(index) do
				table.insert(r_son, t[v])
			end
			table.insert(r, r_son)
		else
			table.cPermutation(t, cNum - 1, r, index, i + 1)
		end
	end
end
