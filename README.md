This repo provides three different methods for implementing fluentd logging for your containers with some basic parsing and filtering for parsing out the log file.  The fluentd conf file is configured to forward the container logs to both Splunk and AWS Cloudwatch Logs where they can be leveraged for alerting or advanced analytics.  The fluent.conf file can be modified to send to only one destination, or other destinations as desired.  If choosing to forward to other destinations, ensure you update the Dockerfile with the required output plugin(s), and the fluent.conf file with the appropriate settings for the plugin.

### Methods
* Method 1 - Deploying fluentd as a service via the td-agent
* Method 2 - Deploying a custom fluentd docker container with the fluent.conf file baked into the image
* Method 3 - Deploying a custom fluentd docker container and passing fluent.conf in the docker run command

### Resources
* [fluentd docker image github repo](https://github.com/fluent/fluentd-docker-image/blob/master/v1.15/debian/entrypoint.sh)
* [docker hub / custom container build steps](https://hub.docker.com/r/fluent/fluentd/)
* [fluentd logging driver for docker](https://docs.docker.com/config/containers/logging/fluentd/)
* [fluentd output plugins](https://www.fluentd.org/plugins/all)
