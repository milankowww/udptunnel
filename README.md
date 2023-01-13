# udptunnel dockerized

Motivation: run udptunnel in a limited docker environment with minimal attack surface:
- single application container, not based on an OS
- no privileges except for networking

## how to build

```
docker build -t udptunnel:latest .
```

## how to run

### display help

```
# docker run --rm udptunnel:latest --help                                     
Usage: udptunnel [OPTION]... [[SOURCE:]PORT] DESTINATION:PORT

-s    --server         listen for TCP connections
-i    --inetd          expect to be started by inetd
-T N  --timeout N      close the source connection after N seconds
                       where no data was received
-S    --syslog         log to syslog instead of standard error
-v    --verbose        explain what is being done
-h    --help           display this help and exit
```

### server, one shot

Run server, one time, in foreground. Accept TCP on 8000, forward to UDP 10.0.0.1:3000

```
# docker run --rm -ti \
    --cap-drop=ALL --cap-add=NET_BIND_SERVICE \
    -p 8000:8000 \
    udptunnel:latest -s 8000 10.0.0.1:3000
```

# the same server, run on background

```
# docker run -d \
    --name udptunnel \
    --restart always \
    --cap-drop=ALL --cap-add=NET_BIND_SERVICE \
    -p 8000 \
    udptunnel:latest -s 8000 10.0.0.1:3000
```

# client, one shot

Run a client listening on udp 4567, connecting to TCP 192.168.10.10:5000

```
# docker run --rm -ti \
    --cap-drop=ALL --cap-add=NET_BIND_SERVICE \
    -p 4567:4567/udp \
    udptunnel:latest 4567 192.168.10.10:5000
```
