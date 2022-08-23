# Fluentd Logging to AWS Cloudwatch Logs and Splunk

This repo provides three different methods for implementing fluentd logging for your chainlink infrastructure to include the Chainlink containers, adapter containers, and Ethereum full node containers with some basic parsing of the log file.  The fluentd conf file is configured to forward the container logs to both Splunk and AWS Cloudwatch Logs where they can be leveraged for alerting, advanced analytics or dashboard creation.  The fluent.conf file can be modified to send to only one destination, or other destinations as desired.  If choosing to forward to other destinations, ensure you update the Dockerfile with the required output plugin(s), and the fluent.conf file with the appropriate settings for the plugin.

### Methods
* [Method 1](https://github.com/linkwellken/fluentd-splunk-cw-logging/tree/main/td-agent) - Deploying fluentd as a service via the td-agent
* [Method 2](https://github.com/linkwellken/fluentd-splunk-cw-logging/tree/main/fluentd-docker-deployment-1) - Deploying a custom fluentd docker container with the fluent.conf file baked into the image
* [Method 3](https://github.com/linkwellken/fluentd-splunk-cw-logging/tree/main/fluentd-docker-deployment-2) - Deploying a custom fluentd docker container and passing fluent.conf in the docker run command

### Resources
* [fluentd docker image github repo](https://github.com/fluent/fluentd-docker-image/blob/master/v1.15/debian/entrypoint.sh)
* [docker hub / custom container build steps](https://hub.docker.com/r/fluent/fluentd/)
* [fluentd logging driver for docker](https://docs.docker.com/config/containers/logging/fluentd/)
* [fluentd output plugins](https://www.fluentd.org/plugins/all)
