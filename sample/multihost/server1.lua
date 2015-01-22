luact.listen('tcp://0.0.0.0:8080')

luact.register('/hello', function ()
	return {
		ref = luact.ref('tcp://192.168.1.2:8080/hello'),
		stop = function (self)
			logger.notice('server1 graceful stop')
			luact.stop()
		end,
		ping = function (self, count)
			logger.info('ping', count)
			if count <= 0 then
				return nil
			else
				return self.ref:pong(count - 1)
			end
		end,
	}
end)

logger.info('server1 start polling')

return true
