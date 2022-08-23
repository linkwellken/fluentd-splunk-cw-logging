This repo provides three different methods for implementing fluentd logging for your containers with some basic parsing and filtering for parsing out the log file.  The fluentd conf file is configured to forward the container logs to both Splunk and AWS Cloudwatch Logs.

### Methods
* Method 1 - Deploying fluentd as a service via the td-agent
* Method 2 - Deploying a custom fluentd docker container with the fluent.conf file baked into the image
* Method 3 - Deploying a custom fluentd docker container and passing fluent.conf in the docker run command

