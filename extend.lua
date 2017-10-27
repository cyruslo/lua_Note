
-- http://snippets.luacode.org/?p=snippets/Deep_copy_of_a_Lua_Table_2
table.clone = function (t,deepnum)
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

table.len = function (t)
	if type(t) ~= "table" then return 0 end
	local n = 0
	for k,v in pairs(t) do n = n + 1 end
	return n
end

-- math.random({0.7, 0.1, 0.2}, {'A', 'B', 'C'})
-- math.random = function(m, n)
-- 	if type(m) == "table" and #m == #n then
-- 		-- 标准化概率表
-- 		local sum = 0
-- 		for _,v in ipairs(m) do sum = sum + v end
-- 		local sm = {}
-- 		for k,v in ipairs(m) do sm[k] = v / sum end
-- 		-- 得到下标
-- 		local r = go.rand.Random()
-- 		for k,v in ipairs(sm) do
-- 			if r <= v then return n[k]
-- 			else r = r - v end
-- 		end
-- 		assert(false)
-- 	end

-- 	if m == nil then return go.rand.Random() end
-- 	local _random = function(m, n)
-- 		m, n = math.min(m, n), math.max(m, n)
-- 		local mi, mf = math.modf(m)
-- 		local ni, nf = math.modf(n)
-- 		if mf == 0 and nf == 0 then
-- 			return go.rand.RandBetween(m, n)
-- 		else
-- 			return m + go.rand.Random() * (n - m)
-- 		end
-- 	end
-- 	if n == nil then return _random(1, m) end
-- 	return _random(m, n)
-- end

-- http://www.cplusplus.com/reference/algorithm/random_shuffle/
-- http://stackoverflow.com/questions/17119804/lua-array-shuffle-not-working
math.shuffle = function(array)
	local counter = #array
	while counter > 1 do
		local index = math.random(counter)
		array[index], array[counter] = array[counter], array[index]
		counter = counter - 1
	end
	return array
end

table.tostring = function (data, _indent)
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

table.find = function (this, value)
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
table.fPermutation = function (t, r, tlen)
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
table.cPermutation = function (t, cNum, r, index, begin)
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

-- local tbl = {}
-- for i=1,54 do
-- 	local point = (i - 1)%13 + 1 
-- 	if i <= 13 then 
-- 		if point < 10 then
-- 			table.insert(tbl, point+110)
-- 		else
-- 			table.insert(tbl, point+1100)
-- 		end
-- 	elseif i >= 14 and i <= 26 then
-- 		if point < 10 then
-- 			table.insert(tbl, point+120)
-- 		else
-- 			table.insert(tbl, point+1200)
-- 		end
-- 	elseif i >= 27 and i <= 39 then
-- 		if point < 10 then
-- 			table.insert(tbl, point+130)
-- 		else
-- 			table.insert(tbl, point+1300)
-- 		end
-- 	elseif i >= 40 and i <= 52 then
-- 		if point < 10 then
-- 			table.insert(tbl, point+140)
-- 		else
-- 			table.insert(tbl, point+1400)
-- 		end
-- 	else
-- 		table.insert(tbl, point+150)
-- 	end
-- end

-- function GetHandPockerPoint(handPocker) 
-- 	local sum5Card = 0
-- 	local maxCardPoint = 0
-- 	local maxCardType = 0
-- 	local haveKing = false
-- 	for i, v in ipairs(handPocker) do
-- 		sum5Card = sum5Card + v.point
-- 		-- 检测是否有大小王
-- 		if v.cardType ~= 5 then
-- 			if maxCardPoint < v.point then
-- 				maxCardPoint = v.point
-- 				maxCardType = v.cardType
-- 			elseif maxCardPoint == v.point and maxCardType > v.cardType then
-- 				maxCardType = v.cardType
-- 			end
-- 		else
-- 			haveKing = true
-- 			-- 王也要参与判断大小，这里是为了比较大小王的大小
-- 			if v.cardType == -1 then
-- 				maxCardPoint = 14 
-- 			elseif v.cardType == -2 then
-- 				maxCardPoint = 15
-- 			end
-- 		end
-- 	end
-- 	return sum5Card, maxCardPoint, maxCardType, haveKing
-- end

-- function CheckBomb(handPocker) 
-- 	local cardPoint = {}
-- 	for i, v in ipairs(handPocker) do
-- 		cardPoint[v.point] = cardPoint[v.point] or 0	
-- 		cardPoint[v.point] = cardPoint[v.point] + 1
-- 	end
-- 	for i, v in pairs(cardPoint) do
-- 		if v == 4 then
-- 			-- 如果双方均是 炸弹牛 则比较该炸弹大小 所以 需要返回炸弹大小
-- 			return true, i, 4
-- 		end
-- 	end
-- 	return false
-- end

-- -- 检测是否为五花牛
-- function CheckFlower(handPocker)
-- 	local flowerNum = 0
-- 	for i, v in ipairs(handPocker) do
-- 		if v.point > 10 then
-- 			flowerNum = flowerNum + 1
-- 		end
-- 	end
-- 	if flowerNum == 5 then
-- 		return true
-- 	end
-- 	return false
-- end

-- -- 获取手牌的牛牛类型
-- function GetHandPockerType(handPocker)
-- 	local t = {}
-- 	for i,v in ipairs(handPocker) do
-- 		local point, cardType = 0, 0
-- 		if math.floor(v / 100) > 10 then
-- 			point = v % 100 
-- 			cardType = (v / 100) % 10
-- 		else
-- 			point = v % 10
-- 			cardType = (v / 10) % 10
-- 		end 
-- 		local card = {
-- 			point = point,
-- 			cardType = cardType,
-- 		}
-- 		table.insert(t, card)
-- 	end
-- 	handPocker = t
-- 	local sum5Card, maxCardPoint, maxCardType, haveKing = GetHandPockerPoint(handPocker)

-- 	if sum5Card % 10 == 0 then
-- 		return 10
-- 	end
-- 	-- 五小牛
-- 	if sum5Card <= 10 then
-- 		return 13
-- 	end

-- 	-- 炸弹牛(如果有炸 则 还返回其 炸大小)
-- 	local bBomb, bombCard = CheckBomb(handPocker)	
-- 	if bBomb == true then
-- 		return 11
-- 	end

-- 	-- 五花牛(百人牛牛 炸弹牛 比 五花牛 大)
-- 	local bFlower = CheckFlower(handPocker)	
-- 	if bFlower == true then
-- 		return 12
-- 	end
-- end

-- function GetBestHandPoker(handPocker)
-- 	local source = handPocker
-- 	local best = nil
-- 	local min = false
-- 	local max = false
-- 	local base = {}
-- 	for i,v in ipairs(handPocker) do
-- 		if v.cardType == 5 and v.point == 1 then
-- 			min = true
-- 		elseif v.cardType == 5 and v.point == 2 then
-- 			max = true
-- 		else
-- 			table.insert(base, v)
-- 		end
-- 	end

-- 	-- 这手牌 有大小王
-- 	if min and max then
-- 		for i=1,13 do
-- 			for j=1,13 do
-- 				local temp    = table.clone(base)
-- 				local tempMin = {
-- 					point 		= i,
-- 					cardType 	= -1, -- 临时使用 -1 表示为小王替换而来的
-- 				}	 
-- 				local tempMax = {
-- 					point 		= j,
-- 					cardType 	= -2, -- 临时使用 -2 表示为大王替换而来的
-- 				}					
-- 				table.insert(temp, tempMin)
-- 				table.insert(temp, tempMax)

-- 				-- 把这幅变换过的牌 去排列成 恰当的牌型
-- 				local group = GroupHandPoker(temp)

-- 				-- 取出最佳的
-- 				if best == nil or CompareHandPocker(group, best) then
-- 					best = group
-- 				end
-- 			end
-- 		end
-- 	-- 有小王
-- 	elseif min then
-- 		for i=1,13 do
-- 			local temp    = table.clone(base)
-- 			local tempMin = {
-- 				point 		= i,
-- 				cardType 	= -1, -- 临时使用 -1 表示为小王替换而来的
-- 			}	 				
-- 			table.insert(temp, tempMin)

-- 			-- 把这幅变换过的牌 去排列成 恰当的牌型
-- 			local group = GroupHandPoker(temp)

-- 			-- 取出最佳的
-- 			if best == nil or CompareHandPocker(group, best) then
-- 				best = group
-- 			end
-- 		end
-- 	-- 有大王
-- 	elseif max then
-- 		for i=1,13 do
-- 			local temp    = table.clone(base)
-- 			local tempMax = {
-- 				point 		= i,
-- 				cardType 	= -2, -- 临时使用 -1 表示为大王替换而来的
-- 			}	 				
-- 			table.insert(temp, tempMax)

-- 			-- 把这幅变换过的牌 去排列成 恰当的牌型
-- 			local group = GroupHandPoker(temp)

-- 			-- 取出最佳的
-- 			if best == nil or CompareHandPocker(group, best) then
-- 				best = group
-- 			end
-- 		end
-- 	else
-- 		best = GroupHandPoker(base)
-- 	end

-- 	return best
-- end

-- local ret = {}
-- math.shuffle(tbl)
-- table.cPermutation(tbl, 5, ret)
-- math.shuffle(ret)
-- -- print(#ret)
--  -- local cal, cnt = 0, 0
--  -- for k,v in pairs(ret) do
--  -- 	cal = cal + 1
--  -- 	if cal % 2 == 0 and math.random(1, 4) == 1 then
--  -- 		print(table.tostring(v))
--  -- 		cnt = cnt + 1
--  -- 		print(cnt)
--  -- 		if cnt == 100000 then
-- 	--  		break
-- 	--  	end
--  -- 	end
--  -- end
-- local cnt = 0
-- local ccc = {[0] = {},}
-- for i,v in ipairs(ret) do
-- 	local btbl = {}
-- 	local n = GetHandPockerType(v)
-- 	if n then
-- 		ccc[n] = ccc[n] or {}
-- 		table.insert(ccc[n], v)
-- 	elseif not table.find(v, 151) and not table.find(v, 152) then
-- 		table.cPermutation(v, 3, btbl)
-- 		local flag = false
-- 		for j,k in ipairs(btbl) do
-- 			local count = 0
-- 			for l,n in ipairs(k) do
-- 				if n > 1000 then
-- 					count = count + 10
-- 				else 
-- 					count = count + n%10
-- 				end
-- 			end
-- 			if count % 10 == 0 then
-- 				flag = true
-- 				local p = 0
-- 			--	print(table.tostring(v))
-- 			--	print(table.tostring(k))
-- 				for _,vv in ipairs(v) do					
-- 					if not table.find(k, vv) then
-- 						if vv > 1000 then
-- 							p = p + 10
-- 						else
-- 							p = p + vv%10
-- 						end
-- 					end
-- 				end
-- 			--	print(p)
-- 				if p > 10 then
-- 					p = p % 10
-- 				end
-- 				ccc[p] = ccc[p] or {}
-- 			--	print(p)
-- 				table.insert(ccc[p], v)
-- 				break
-- 			end
-- 		end
-- 		if flag == false and #ccc[0] < 500 then
-- 			ccc[0] = ccc[0] or {}
-- 			table.insert(ccc[0], v)
-- 		end
-- 	end
-- 	if i == 100000 then
-- 		break
-- 	end
-- end

-- for i=0,13 do
-- 	if i == 0 then
-- 		print(" ********** 没牛 ********** ")
-- 		local S = "["
-- 		for _,v in ipairs(ccc[0]) do
-- 			local s = "[" 
-- 			for j,vv in ipairs(v) do
-- 				if j ~= 5 then
-- 					s = s .. vv .. ","
-- 				else
-- 					s = s .. vv
-- 				end
-- 			end
-- 			s = s .. "]," .. "\n"
-- 			S = S .. s
-- 		end
-- 			S = S .. "]"
-- 			print(S)
-- 	elseif i >= 1 and i <= 9 then
-- 		print(" ********** " .. "牛" .. i .. " ********** ")
-- 		local S = "["
-- 		for _,v in ipairs(ccc[i]) do
-- 			local s = "[" 
-- 			for j,vv in ipairs(v) do
-- 				if j ~= 5 then
-- 					s = s .. vv .. ","
-- 				else
-- 					s = s .. vv
-- 				end
-- 			end
-- 			s = s .. "]," .. "\n"
-- 			S = S .. s
-- 		end
-- 			S = S .. "]"
-- 			print(S)
-- 	elseif i == 10 then
-- 		print(" ********** 牛牛 ********** ")
-- 		local S = "["
-- 		for _,v in ipairs(ccc[10]) do
-- 			local s = "[" 
-- 			for j,vv in ipairs(v) do
-- 				if j ~= 5 then
-- 					s = s .. vv .. ","
-- 				else
-- 					s = s .. vv
-- 				end
-- 			end
-- 			s = s .. "]," .. "\n"
-- 			S = S .. s
-- 		end
-- 			S = S .. "]"
-- 			print(S)
-- 	elseif i == 11 then
-- 		print(" ********** 炸弹牛 ********** ")
-- 		local S = "["
-- 		for _,v in ipairs(ccc[11]) do
-- 			local s = "[" 
-- 			for j,vv in ipairs(v) do
-- 				if j ~= 5 then
-- 					s = s .. vv .. ","
-- 				else
-- 					s = s .. vv
-- 				end
-- 			end
-- 			s = s .. "]," .. "\n"
-- 			S = S .. s
-- 		end
-- 			S = S .. "]"
-- 			print(S)
-- 	elseif i == 12 then
-- 		print(" ********** 五花牛 ********** ")
-- 		local S = "["
-- 		for _,v in ipairs(ccc[12]) do
-- 			local s = "[" 
-- 			for j,vv in ipairs(v) do
-- 				if j ~= 5 then
-- 					s = s .. vv .. ","
-- 				else
-- 					s = s .. vv
-- 				end
-- 			end
-- 			s = s .. "]," .. "\n"
-- 			S = S .. s
-- 		end
-- 			S = S .. "]"
-- 			print(S)
-- 	elseif i == 13 then
-- 		print(" ********** 五小牛 ********** ")
-- 		local S = "["
-- 		for _,v in ipairs(ccc[13]) do
-- 			local s = "[" 
-- 			for j,vv in ipairs(v) do
-- 				if j ~= 5 then
-- 					s = s .. vv .. ","
-- 				else
-- 					s = s .. vv
-- 				end
-- 			end
-- 			s = s .. "]," .. "\n"
-- 			S = S .. s
-- 		end
-- 			S = S .. "]"
-- 			print(S)
-- 	end
-- end
