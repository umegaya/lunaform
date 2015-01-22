local thread_id = luact.thread_id
local machine_id = luact.machine_id
local clock = luact.clock

luact.listen('tcp://0.0.0.0:8080')

logger.warn(('hello yue this is %x:%u'):format(machine_id, thread_id))
