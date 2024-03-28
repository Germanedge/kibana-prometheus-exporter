# build stage
FROM germanedge-docker.artifactory.new-solutions.com/edge-one/ge-ubuntu-node:0.32.0 as upstream

USER root

ARG npm_config_registry
ARG npm_config_auth
ARG npm_config_always_auth
ARG npm_config_email

COPY . /app

RUN if ! [ -f ".npmrc" ]; then \
      echo registry=$npm_config_registry > .npmrc && \
      echo _auth=$npm_config_auth >> .npmrc && \
      echo always-auth=$npm_config_always_auth >> .npmrc && \
      echo email=$npm_config_email >> .npmrc; \
    fi
RUN yarn install
#RUN yarn lint
RUN yarn build
RUN rm -f .npmrc

FROM ubuntu:22.04

RUN mkdir /kibana-plugin

COPY --from=upstream /app/target/prometheus_exporter-${STACK_VERSION}.zip /kibana-plugin/prometheus-exporter.zip
