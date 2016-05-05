# lunaform
[luact](http://github.com/umegaya/luact)'s command line frontend by docker
run luact instace as docker container with some convenient command line option including pipework integrated SDN feature.

# getting start

## install
```
git clone https://github.com/umegaya/yue.git
cd yue
cp yue path/to/your/bin/
```

## run simple test
```
yue sample/hello.lua
```

## run simple test with 4 thread/# of cpu core
```
yue -c 4 sample/hello.lua
yue -c false sample/hello.lua
```

## run echo server
```
# publish port 8080 of server to 18080 of docker host, client can access via $DOCKER_HOST:18080
yue --daemon -d publish=8080:18080 sample/server.lua
# or, you can assign unique ip address and use port 8080 directly 
# (but if you run yue on OSX/Windows, need to setup host network adoptor of boot2docker-vm. see boot2docker-vm settings for detail)
yue --daemon -a 192.168.1.1/24 sample/server.lua
```

## try 2 server instances communication	
```
./sample/multihost/run.sh
```

## other resources
- [luact API reference](https://github.com/umegaya/luact#%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E9%96%A2%E6%95%B0)


# boot2docker-vm settings
we saw it is possible to give static ip address for each yue server process like following:
```
yue --daemon -a 192.168.1.1/24 sample/server.lua
```
but this ip is only valid for between container cluster, we cannot access our yue container from outside of them.
it is inconvenient when we try to develop client with yue server, following section will describe how we can enable access to yue server container from outside. (sorry osx only!!)

1. setup VirtualBox network interface
- GUI: like [that](https://blog.apar.jp/linux/402/)
- CUI: like below
``` bash
$ VBoxManage hostonlyif create
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Interface 'vboxnet1' was successfully created
$ VBoxManage hostonlyif ipconfig vboxnet1 --ip 192.168.99.1 --netmask 255.255.255.0
```

2. apply to boot2docker-vm by using yue
``` bash
# use vboxnet1 as network interface for yue (nic3 is used)
yue setup vboxnet1
# if your boot2docker-vm's nic3 is used for other purpose, specify nic number as 2nd argument
yue setup vboxnet1 4
```






