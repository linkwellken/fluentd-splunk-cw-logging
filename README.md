Docker Deployment
This repo provides three different methods for implementing fluentd logging for your containers - installing fluentd as a service via the td-agent, and installing fluentd as a docker container.  The fluentd conf file is configured to forward the container logs to both Splunk and Cloudwatch Logs Group.

### Methods
Method 1 - Deploying fluentd as a service via the td-agent
Method 2 - Deploying a custom fluentd docker container with the fluent.conf file baked into the image
Method 3 - Deploying a custom fluentd docker container and passing fluent.conf in the docker run command

### Resources
* [fluentd docker image github repo](https://github.com/fluent/fluentd-docker-image/blob/master/v1.15/debian/entrypoint.sh)
* [docker hub / container build steps](https://hub.docker.com/r/fluent/fluentd/)
* [fluentd logging driver for docker](https://docs.docker.com/config/containers/logging/fluentd/)

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
COPY entrypoint.sh /bin

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
    hec_host <splunk-ip>
    hec_port 8088
    hec_token <splunk-hec-token>
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

