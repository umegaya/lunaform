local exception = luact.exception
local restart 
if luact.thread_id == 1 then
	luact.listen('tcp://0.0.0.0:8080')
	luact.register(("/system/bomb"):format(seed), function (s)		
		if restart then
			luact.clock.sleep(0.5)
		else
			restart = true
		end
		return {
			explode = function () 
				exception.raise('actor_error', 'bomb!!') 
			end,
			status = function ()
				return "ok"
			end,
		}
	end, seed)
else
	local v = luact.ref("tcp://127.0.0.1:8080/system/bomb")
	local ok, r = pcall(v.explode)
	assert((not ok) and r:is('actor_error'))
	-- vid actor autometically restart and message sender wait for recovery of actor
	assert(v.status() == "ok")
end
logger.info('success')
