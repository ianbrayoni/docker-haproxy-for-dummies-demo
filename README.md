[![Build Status](https://travis-ci.org/ianbrayoni/docker-haproxy-for-dummies-demo.svg?branch=master)](https://travis-ci.org/ianbrayoni/docker-haproxy-for-dummies-demo)

# Docker-Compose HAProxy for dummies demo
Load balancing is essential for high availability, minimise downtime, seamless maintenance, distribute load and take advantage of features supported by load balancing software.

Suppose you need to quickly learn about load-balancing and your tools of choice are `HAProxy` and `Docker`, look no further. This short demo shows how to use `docker-compose` to create a web service connected to a load balancer.

# Software
At the point of this release, these are the versions used;

#### Docker
    Client:
        Version:	   17.12.0-ce
        API version:   1.35
        Go version:	   go1.9.2
        Git commit:	   c97c6d6
        Built:	   Wed Dec 27 20:03:51 2017
        OS/Arch:	   darwin/amd64

    Server:
        Engine:
            Version:	17.12.0-ce
            API version:	1.35 (minimum version 1.12)
            Go version:	go1.9.2
            Git commit:	c97c6d6
            Built:	        Wed Dec 27 20:12:29 2017
            OS/Arch:	linux/amd64
            Experimental:	true

#### Docker-Compose
    docker-compose version 1.18.0, build 8dd22a9

# Install
The instructions assume that you have already installed [Docker](https://docs.docker.com/installation/) and [Docker Compose](https://docs.docker.com/compose/install/). 

In order to get started be sure to clone this project onto your Docker Host. 

    git clone https://github.com/ianbrayoni/docker-haproxy-for-dummies-demo.git .

# How to get up and running
Spin up the services and scale the web tier to a number of your choice. E.g:
    
    docker-compose up --scale web=5

To see all running services, run from another terminal tab.

    docker-compose ps

Check that the service is running by curlng the IP from the command line or view the IP from a web browser. The address reports the number of times page has been seen and the hostname of the web container that has served the request.

### Curling from the command line
    curl 0.0.0.0:8000
    
### Web browser 

    http://localhost:8000/

Output from both the browser or curl

    Hello World!
    I have been seen 6 times.

    My hostname is 112ef0991ede.

A snippet of the logs

    web_1    | 172.22.0.6 - - [18/Mar/2018 15:48:09] "GET / HTTP/1.1" 200 -
    web_2    | 172.22.0.6 - - [18/Mar/2018 15:48:24] "GET / HTTP/1.1" 200 -
    web_3    | 172.22.0.6 - - [18/Mar/2018 15:48:48] "GET / HTTP/1.1" 200 -
    web_1    | 172.22.0.6 - - [18/Mar/2018 15:49:00] "GET / HTTP/1.1" 200 -
    web_2    | 172.22.0.6 - - [18/Mar/2018 15:49:16] "GET / HTTP/1.1" 200 -
    web_3    | 172.22.0.6 - - [18/Mar/2018 15:49:26] "GET / HTTP/1.1" 200 -


### HA Proxy Statistics
Hit the following url

    http://localhost:1936/

# Additional Notes
[dockercloud/haproxy](https://github.com/docker/dockercloud-haproxy) is used because it balances between linked containers and, if launched in Docker Cloud or using Docker Compose `v2` or `v3`, reconfigures itself when a linked cluster member redeploys, joins or leaves.
It is also compatabile with Docker Swarm.

Further configuration to HAProxy can be done using environment variables. For further details see [configuration](https://github.com/docker/dockercloud-haproxy/blob/master/README.md#configuration)

    environment:
        - STATS_AUTH="admin:admin"
        - STATS_PORT=1936

Feel free to configure and play with the following load-balancing algorithms:
* Round-Robin `roundrobin`
* Weighted Round-Robin
* Least Connections `leastconn`
* Weighted Least Connections
* Source/IP Hash `source`
* Random

This can be done using `BALANCE` environment variable.

    environment:
        - STATS_AUTH="admin:admin"
        - STATS_PORT=1936
        - BALANCE=leastconn

# Limitations
The load balancer, HAProxy, container is a single point of failure.

# Next steps
1. Set up a redudant or highly available load-balancer using tools like `keepalived`
2. Explore container orchestration tools like `kurbenetes` and `docker-swarm`
3. Deploy to `docker-cloud`

# Acknowledgement
1. [@vegasbrianc's demo](https://github.com/vegasbrianc/docker-compose-demo)
2. https://github.com/docker/dockercloud-haproxy
