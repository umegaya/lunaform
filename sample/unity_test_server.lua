luact.listen('tcp://0.0.0.0:8080')

luact.register('/srv', {multi_actor=true}, function ()
	return {
		echo = function (self, v)
			local p = luact.peer("/sys")
			logger.info('client call', p:GetUnityVersion(true), p:GetUnityVersion(false))
			return v
		end,
	}
end)

return true
