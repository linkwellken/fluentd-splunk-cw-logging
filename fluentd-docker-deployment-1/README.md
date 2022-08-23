## Method 2 - Docker deployment with fluent.conf baked into the image
```
1. mkdir /opt/fluentd
2. cd /opt/fluentd
3. sudo yum install git
4. git clone https://github.com/linkwellken/fluentd-splunk-cw-logging.git
5. cd fluentd-splunk-cw-logging/fluentd-docker-deployment-1
6. sudo chmod +x entrypoint.sh
7. docker build -t custom-fluentd:latest ./
```

### Docker run command
```
docker run -d -p 24224:24224 --restart unless-stopped --name fluentd  custom-fluentd:latest
```

### docker log driver flags for sending logs to fluentd container
https://docs.docker.com/config/containers/logging/fluentd/
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
```
