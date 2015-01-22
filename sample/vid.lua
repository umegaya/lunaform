
if luact.thread_id == 1 then
	luact.listen('tcp://0.0.0.0:8080')
	local idlist = {}
	for seed=101,105 do
		luact.register(("/user/id%d"):format(seed), function (s)
			return {
				id = s,
				hello = function (self) return "my id is "..tostring(self.id) end,
			}
		end, seed)
	end
else
	local target_id = 101 + (luact.thread_id % 5)
	local vid = luact.ref(("tcp://127.0.0.1:8080/user/id%d"):format(target_id))
	local r = vid:hello()
	logger.info('msg from vid', r)
	assert(r == "my id is "..tostring(target_id))
end

