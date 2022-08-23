### Method 2 - Docker deployment with fluent.conf baked into the image
```
1. mkdir /lw/fluentd
2. cd /lw/fluentd
3. sudo yum install git
4. git clone https://github.com/linkwellken/fluentd-splunk-cw-logging.git
5. sudo chmod +x entrypoint.sh
5. docker build -t custom-fluentd:latest ./
6. docker run -d -p 24224:24224 --restart unless-stopped --name fluentd  custom-fluentd:latest
```

### docker log driver flags for sending logs to fluentd container
https://docs.docker.com/config/containers/logging/fluentd/
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
```