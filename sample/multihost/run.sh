#!/bin/bash

rm -rf sv1 sv2

# because these are run on same workspace, force change logdir and datadir between these 2 server (-w, --workdir)
./yue --daemon -a 192.168.1.1/24 -w work/sv1 sample/multihost/server1.lua
./yue --daemon -a 192.168.1.2/24 --workdir=work/sv2 sample/multihost/server2.lua

echo "wait for server booting"
sleep 7
tail -F ./work/sv1/logs/1/current ./work/sv2/logs/1/current
