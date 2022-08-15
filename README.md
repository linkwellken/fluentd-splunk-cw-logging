# fluentd-splunk-cw-logging
https://docs.docker.com/config/containers/logging/fluentd/

## install td-agent
```curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh```

## splunk output plugin install
https://github.com/splunk/fluent-plugin-splunk-hec
```td-agent-gem install fluent-plugin-splunk-hec```

## aws output plugin install
https://github.com/fluent-plugins-nursery/fluent-plugin-cloudwatch-logs
```td-agent-gem install fluent-plugin-cloudwatch-logs```

## /etc/td-agent/td-agent.conf
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
    json_handler json
    format json
  </store>
</match>










## run
systemctl start td-agent





##fluentbit
https://fluentbit.io/

### Amazon-Linux Install
curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh

###aws
https://github.com/aws/aws-for-fluent-bit/tree/master/examples/fluent-bit/systems-manager-ec2

### splunk
https://docs.fluentbit.io/manual/pipeline/outputs/splunk
