#!/bin/bash

rm -rf sv1 sv2

# because these are run on same workspace, force change logdir and datadir between these 2 server (-w, --workdir)
./yue --daemon -a 192.168.1.1/24 -w sv1 sample/multihost/server1.lua
./yue --daemon -a 192.168.1.2/24 --workdir=sv2 sample/multihost/server2.lua

echo "wait for server booting"
sleep 7
tail -F ./sv1/logs/1/current ./sv2/logs/1/current
