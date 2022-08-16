# fluentd-splunk-cw-logging

## Method 1 - Run fluentd as td-agent service
1. Install td-agent and output plugins
2. Modify the td-agent file with the config below
3. Start your docker container with the fluentd logging driver
4. Confirm log delivery to Splunk and CWL.

### install td-agent
```
curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh
```

### splunk output plugin install
https://github.com/splunk/fluent-plugin-splunk-hec
```
td-agent-gem install fluent-plugin-splunk-hec
```

### aws output plugin install
https://github.com/fluent-plugins-nursery/fluent-plugin-cloudwatch-logs
```
td-agent-gem install fluent-plugin-cloudwatch-logs
```

### /etc/td-agent/td-agent.conf
```
# docker logging-driver in
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

#filter
<filter **>
  @type parser
  key_name log
  reserve_data true
  <parse>
    @type json
  </parse>
</filter>


#splunk out
<match **>
  @type copy
  <store>
    @type splunk_hec
    hec_host 192.168.136.29
    hec_port 8088
    hec_token 444b0d93-8e37-42b8-8fe7-64723e0331c1
    insecure_ssl true
    index chainlink
    source ERT
    sourcetype chainlink:logs
    <buffer>
      flush_interval 1s
    </buffer>
    <fields>
      container_id
      container_name
      log
      source
    </fields>
  </store>

#cloudwatch out
  <store>
    @type cloudwatch_logs
    log_group_name ERT-CL-Logs
    log_stream_name CL_TEST1
    auto_create_stream true
    region us-west-2
    <buffer>
      flush_interval 1s
    </buffer>
  </store>
</match>
```

##3 run
```
systemctl restart td-agent
systemctl start td-agent
```

### docker log driver flags for container monitoring
https://docs.docker.com/config/containers/logging/fluentd/
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
```

## Method 2 - Docker Deployment

### fluentd docker image github repo
https://github.com/fluent/fluentd-docker-image/blob/master/v1.15/debian/entrypoint.sh

### docker hub / container build steps
https://hub.docker.com/r/fluent/fluentd/

```
1. mkdir /lw/fluentd
2. cd /lw/fluentd
3. Copy over the three files below - entrypoint.sh, Dockerfile, and fluent.conf 
```

### entrypoint.sh
```
#!/bin/sh

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep -e ' \-c' -e ' \-\-config' ; then
       set -- "$@" --config /fluentd/etc/${FLUENTD_CONF}
    fi

    if ! echo $@ | grep -e ' \-p' -e ' \-\-plugin' ; then
       set -- "$@" --plugin /fluentd/plugins
    fi
fi

exec "$@"
```

### Dockerfile
```
FROM fluent/fluentd:v1.15-debian-1

USER root

 # cutomize following instruction as you wish
#RUN apt-get update && apt-get install -y curl \
# && sudo  curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-td-agent4.sh | sh \
# && sudo td-agent-gem install fluent-plugin-splunk-hec \
# && sudo td-agent-gem install fluent-plugin-cloudwatch-logs
RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install fluent-plugin-splunk-hec \
 && sudo gem install fluent-plugin-cloudwatch-logs \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem


COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

USER fluent
```

### fluent.conf
```
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

#filter
<filter **>
  @type parser
  key_name log
  reserve_data true
  <parse>
    @type json
  </parse>
</filter>

#splunk out
<match **>
  @type copy
  <store>
    @type splunk_hec
    hec_host 192.168.136.29
    hec_port 8088
    hec_token 444b0d93-8e37-42b8-8fe7-64723e0331c1
    insecure_ssl true
    index chainlink
    source ERT
    sourcetype chainlink:logs
    <buffer>
      flush_interval 1s
    </buffer>
    <fields>
      container_id
      container_name
      log
      source
    </fields>
  </store>

#cloudwatch out
  <store>
    @type cloudwatch_logs
    log_group_name ERT-CL-Logs
    log_stream_name CL_TEST1
    auto_create_stream true
    region us-west-2
    <buffer>
      flush_interval 1s
    </buffer>
  </store>
</match>
```

### docker build image command:
```
docker build -t custom-fluentd:latest ./
```

### docker run command:
```
docker run -d -p 24224:24224 --restart unless-stopped --name fluentd  custom-fluentd:latest
```
