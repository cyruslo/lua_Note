
-- Lua协同程序的工作机制
function foo(a)
	print("foo", a)
	return coroutine.yield(2 * a)
end

co = coroutine.create(function ( a, b )
	print("co-body1", a, b)
	local r = foo(a + 1)
	print("co-body2", r)
	local r, s = coroutine.yield(a + b, a - b)
	print("co-body3", r, s)
	return b, "end"
end)

print("main1", coroutine.resume(co, 1, 10))
print("main2", coroutine.resume(co, "r"))
print("main3", coroutine.resume(co, "x", "y"))
print("main4", coroutine.resume(co, "x", "y"))

-- 输出结果:
--[[
		co-body1	1	10
		foo	2
		main1	true	4
		co-body2	r
		main2	true	11	-9
		co-body3	x	y
		main3	true	10	end
		main4	false	cannot resume dead coroutine
--]]