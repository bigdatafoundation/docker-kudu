# Docker image for Kudu
![logo](http://getkudu.io/img/logo.png)


## Supported tags and respective `Dockerfile` links
- NONE YET - This Dockerfile is UNDER DEVELOPMENT.


## What is Kudu?
Kudu is an open source storage engine for structured data which supports low-latency random access together with effi- cient analytical access patterns. Kudu distributes data using horizontal partitioning and replicates each partition using Raft consensus, providing low mean-time-to-recovery and low tail latencies. Kudu is designed within the context of the Hadoop ecosystem and supports many modes of access via tools such as [Cloudera Impala](http://impala.io/), [Apache Spark](http://spark.apache.org/), and [MapReduce](https://hadoop.apache.org/).

[http://getkudu.io/](http://getkudu.io/)


## What is Docker?
Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications. Consisting of Docker Engine, a portable, lightweight runtime and packaging tool, and Docker Hub, a cloud service for sharing applications and automating workflows, Docker enables apps to be quickly assembled from components and eliminates the friction between development, QA, and production environments. As a result, IT can ship faster and run the same app, unchanged, on laptops, data center VMs, and any cloud.

[https://www.docker.com/whatisdocker/](https://www.docker.com/whatisdocker/)

### What is a Docker Image?
Docker images are the basis of containers. Images are read-only, while containers are writeable. Only the containers can be executed by the operating system.

[https://docs.docker.com/terms/image/](https://docs.docker.com/terms/image/)


## How to use this image?

## The Easy Way

### Using docker-compose
```bash
docker-compose up -d
```

### Starting a Kudu console
```bash
docker run --rm -it --link <kudu_tserver_name_or_id>:kudu_tserver -e KUDU_TSERVER=kudu_tserver <generated image name or id> cli status
```

## The Long Way

### Building this Docker image
```bash
docker build -t kudu .
```

### (Optional) Create Data containers
```bash
docker create --name kudu-master-data -v /data/kudu-master
docker create --name kudu-tserver-data -v /data/kudu-tserver
```

### Starting the Kudu Master
```bash
docker run -d --name kudu-master -p 8051:8051 \
-e KUDU_OPTS="--logtostderr --use_hybrid_clock=false" \
kudu master
```

### Starting the Kudu TabletServer
```bash
docker run -d --name kudu-tserver -p 8050:8050 --link kudu-master \
-e KUDU_MASTER=kudu-master \
-e KUDU_OPTS="--logtostderr --use_hybrid_clock=false" \
kudu tserver
```

### Tailing the logs
```bash
docker logs -f kudu-master
docker logs -f kudu-tserver
```

### Starting a Kudu console
```bash
docker run --rm -it --link kudu-tserver -e KUDU_TSERVER=kudu-tserver kudu cli status
```

### Accessing the web interfaces
Each component provide its own web UI. Open you browser at one of the URLs below, where `dockerhost` is the name / IP of the host running the docker daemon. If using Linux, this is the IP of your linux box. If using OS X or Windows (via Docker-Machine), you can find out your docker host by typing `docker-machine ip default`.

| Component               | Port                                              |
| ----------------------- |-------------------------------------------------- |
| Master                  | [http://dockerhost:8051](http://dockerhost:8051)  |
| TabletServer            | [http://dockerhost:8050](http://dockerhost:8050)  |


### Other links
- https://github.com/cloudera/kudu-examples/wiki/Docker-based-tutorial
