luact.listen('tcp://0.0.0.0:8080')

logger.warn('setup sync vid worker')
if luact.thread_id == 1 then
	luact.register("/system/sync", function ()
		return {
			size = size,
			progress = {},
			latch = function (self, tid, pr)
				self.progress[tid] = pr
				while true do 
					local achieved = true
					for i=1,luact.n_core do
						local tmp = self.progress[i]
						if (not tmp) or (tmp < pr) then
							achieved = false
							break
						end
					end
					if achieved then
						break
					else
						luact.clock.sleep(0.1)
					end
				end
			end,
		}
	end)
else
	luact.clock.sleep(0.5)
end


logger.warn('get sync ref and setup frontend vid worker')
local sync = luact.ref("tcp://127.0.0.1:8080/system/sync")
local seed = luact.thread_id * 111
local function frontend_actor_ctor(s)
	return {
		id = s,
		hello = function (self) 
			return self.id
		end,
	}
end
local actor = luact.register("/frontend", {multi_actor=true}, frontend_actor_ctor, seed)
sync:timed_latch(60, luact.thread_id, 1)


logger.warn('create cache of vid')
local ref = luact.ref("tcp://127.0.0.1:8080/frontend")
local count = 0
while true do
	local ret = ref:hello(luact.thread_id)
	if ret ~= seed then
		logger.debug('return from another thread', seed, ret)
		break
	end
	count = count + 1
	if count > 100 then
		assert(false)
	end
end
sync:timed_latch(60, luact.thread_id, 2)


logger.warn('unregister vid worker other than thread_id == 3\'s')
if luact.thread_id ~= 3 then
	logger.report('unregister actor', luact.thread_id, actor)
	luact.unregister("/frontend", actor)
end
sync:timed_latch(60, luact.thread_id, 3)


logger.warn('there is only 1 worker, so return value should be same for all caller thread')
local v = ref:hello()
logger.report('ref:hello returns', v)
assert(333 == v)
sync:timed_latch(60, luact.thread_id, 4)


logger.warn('thread 3 remove its actor. so there is no actor under frontend')
if luact.thread_id == 3 then
	luact.unregister("/frontend", actor)
end
sync:timed_latch(60, luact.thread_id, 5)


logger.warn('now no worker is assigned at /fronend, so calling ref caused error')
local ent = (require 'luact.vid').debug_getent("tcp://127.0.0.1:8080/frontend")
assert((not ent) or (not ent:alive()))
local ok, r = pcall(ref.hello, ref)
assert((not ok) and r:is('actor_not_found'))
sync:timed_latch(60, luact.thread_id, 6)


logger.warn('then you can add new actor to same vid')
if luact.thread_id == 4 then
	actor = luact.register("/frontend", {multi_actor=true}, frontend_actor_ctor, seed)
end
sync:timed_latch(60, luact.thread_id, 7)

logger.warn('again there is only 1 worker, so return value should be same for all caller thread')
local v = ref:hello()
logger.report('ref:hello returns', v)
assert(444 == v)
logger.notice('success')

