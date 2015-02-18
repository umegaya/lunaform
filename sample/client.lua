local ref = luact.ref('tcp://192.168.1.2:8080/srv')

local start = luact.clock.get()
logger.info('start loop')
for i=1,10000 do
	assert(true == ref.echo(true))
end
logger.info('end loop', luact.clock.get() - start)
	
