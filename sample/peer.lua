
if luact.thread_id == 1 then
	luact.listen('tcp://0.0.0.0:8080')
	luact.register("/system", function ()
		local peers = {}
		return {
			register = function (id)
				peers[id] = assert(luact.peer("/notify"))
				return "pass"..tostring(id)
			end,
			login = function (id, pass)
				if pass == ("pass"..tostring(id)) then
					-- normal peer rpc
					for k,v in pairs(peers) do
						logger.report('peers', k, v, v.conn)
						local r = v.on_enter(id)
						logger.report('peer call result', r)
						assert(r == (id + 100))
					end
					-- async peer rpc (with check result)
					local evs = {}
					for k,v in pairs(peers) do
						table.insert(evs, v.async_on_enter(id))
					end
					local ret = luact.event.join(luact.clock.alarm(5.0), unpack(evs))
					for _, r in ipairs(ret) do
						local t, obj, ok, rv = unpack(r)
						if t == 'end' then
							assert(ok and (rv == id + 100))
						end
					end
					-- notify peer rpc
					for k,v in pairs(peers) do
						v.notify_on_enter(id)
					end
				end
			end,
		}
	end)
else
	local recv = 0
	luact.register("/notify", function ()
		return {
			on_enter = function (id)
				recv = recv + 1 
				return id + 100
			end,
		}
	end)
	local vid = luact.ref("tcp://127.0.0.1:8080/system")
	local pwd = vid.register(100 + luact.thread_id) 
	assert(pwd == "pass"..(100 + luact.thread_id))
	if luact.thread_id == 2 then
		luact.clock.sleep(1.0)
		vid.login(100 + luact.thread_id, pwd)
	end
	local cnt = 0
	while recv < 3 do
		cnt = cnt + 1
		if cnt > 30 then
			luact.exception.raise('fatal', 'notification has not come within timeout')
		end
		luact.clock.sleep(0.1)
	end
	logger.info('finished')
end

