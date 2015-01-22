local ref = luact.ref('http://192.168.1.1/srv')

for i=1,100000 do
	assert(true == ref:echo(true))
end
