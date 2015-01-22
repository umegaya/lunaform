luact.listen('tcp://0.0.0.0:8080')

local a = luact.register('/hello', function ()
	return {
		ref = luact.ref('tcp://192.168.1.1:8080/hello'),
		start = function (self)
			return self:pong(10)
		end,
		pong = function (self, count)
			logger.info('pong', count)
			if count <= 0 then
				self.ref:notify_stop()
				luact.clock.sleep(0.1)
				-- because no more be able to return result to server1, stop immediately
				logger.notice('server2 graceful stop')
				luact.stop()
				return nil
			else
				return self.ref:ping(count - 1)
			end
		end,
	}
end)

assert(nil == a:start())

return true
