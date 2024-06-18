To bring up the containers run 

`make up` or `make up-build`

There are two containers: `nginx1` and `nginx2`. The `nginx1` container is managed by `s6`.

To bring down the containers run

`make down` 

or to bring down the containers with a specific stop timeout run

`make down-15` (stop timeout: 15s)

`make down-20` (stop timeout: 20s)

`make down-30` (stop timeout: 30s)

`make down-60` (stop timeout: 60s)

`make down-90` (stop timeout: 90s)

To stop the containers run `make stop` or `make stop-nginx1` or `make stop-nginx2` to stop a specific container.