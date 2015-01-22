local thread_id = luact.thread_id

function luact.root.reply(msg)
	return "reply from:"..tostring(thread_id)..":"..msg
end

local act = luact({
	hello = function ()
		return "world!"
	end,
})
function luact.root.get_test_actor()
	return act
end

if (thread_id % 2) == 0 then
	local a = luact.root_of(nil, thread_id - 1) -- get prev thread's root actor
	logger.info(a.reply('hello'))
	assert(a.reply('hello') == "reply from:"..tostring(thread_id - 1)..":hello")
	logger.info(a.get_test_actor().hello())
	assert(a.get_test_actor().hello() == "world!")
end

