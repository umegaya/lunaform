luact.listen('tcp://0.0.0.0:8080')
	
local seed = luact.thread_id * 111
luact.register("/system/frontend", { multi_actor = true }, function (s)
	return {
		id = s,
		hello = function (self, tid)
			logger.info('hell from ', tid) 
			return self.id
		end,
	}
end, seed)

luact.clock.sleep(1.0)
local ent = (require 'luact.vid').debug_getent("tcp://127.0.0.1:8080/system/frontend")
assert(ent.n_id == luact.n_core)

local ref = luact.ref("tcp://127.0.0.1:8080/system/frontend")
local count = 0
while true do
	local ret = ref:hello(luact.thread_id)
	if ret ~= seed then
		logger.info('return from another thread', seed, ret)
		break
	end
	count = count + 1
	if count > 100 then
		assert(false)
	end
end

logger.notice('success')
