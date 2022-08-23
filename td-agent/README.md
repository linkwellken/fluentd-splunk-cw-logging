## Method 1 - Run fluentd as the td-agent service
1. Install td-agent and output plugins
2. Clone the repo
3. Update the variables for Splunk and CWL as needed.
4. Start the docker container with the fluentd logging driver
5. Confirm log delivery to Splunk and CWL.

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

### Create /etc/td-agent/td-agent.conf
```
cd /opt
git clone https://github.com/linkwellken/fluentd-splunk-cw-logging.git
cd fluentd-splunk-cw-logging/td-agent
cp td-agent.conf /etc/td-agent
```

### start agent
```
systemctl enable td-agent
systemctl start td-agent
```

### docker log driver flags for forwarding logs to fluentd
https://docs.docker.com/config/containers/logging/fluentd/
```
docker run -d \
    --log-driver=fluentd \
    --log-opt fluentd-address=localhost:24224 \
```
