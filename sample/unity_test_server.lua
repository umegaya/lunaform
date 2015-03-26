luact.listen('tcp://0.0.0.0:8080')

luact.register('/srv', {multi_actor=true}, function ()
	return {
		echo = function (self, v)
			local p = luact.peer("/sys")
			print('client call', p:GetUnityVersion(true))
			print('client2 call', p:GetUnityVersion(false))
			print(v)
			return v
		end,
	}
end)

return true
