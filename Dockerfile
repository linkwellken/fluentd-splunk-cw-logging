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
