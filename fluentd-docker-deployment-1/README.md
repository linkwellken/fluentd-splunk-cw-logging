## Method 2 - Docker deployment with fluent.conf baked into the image
```
1. mkdir /opt/fluentd
2. cd /opt/fluentd
3. sudo yum install git
4. git clone https://github.com/linkwellken/fluentd-splunk-cw-logging
5. cd fluentd-splunk-cw-logging/fluentd-docker-deployment-1
6. sudo chmod +x entrypoint.sh

```

### Modify fluent.conf for environment
```
vi fluent.conf
1. For splunk_out, update splunk-ip, splunk-hec, and index, source, sourcetype if needed
2. For cloudwatch_out, update log_group_name, log_stream_name, and region
```

### Build the container
```
docker build -t custom-fluentd:latest ./
```

### Docker run command
```
docker run -d -p 24224:24224 --restart unless-stopped --name fluentd  custom-fluentd:latest
```

### docker log driver flags for sending logs to fluentd container
https://docs.docker.com/config/containers/logging/fluentd/

#### Chainlink
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
    --log-opt tag=EGT-Chainlink
```

#### Adapters
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
    --log-opt tag=EGT-Adapters
```

#### Fluentd (send container logs to itself and forward on)
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
    --log-opt tag=EGT-Fluentd
```

#### Geth
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
    --log-opt tag=geth_node
```

#### Teku
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
    --log-opt tag=teku_node
```

