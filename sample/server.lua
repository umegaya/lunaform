luact.listen('tcp://0.0.0.0:8080')

luact.register('/srv', {multi_actor=true}, function ()
	return {
		echo = function (v)
			return v
		end,
	}
end)

return true
