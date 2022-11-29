FROM hashicorpdemoapp/product-api:v0.0.22 as base

FROM ubuntu:20.04

ENV ENVOY_VERSION=1.24.0
ENV CONSUL_VERSION=1.14.1


COPY --from=base /app/product-api /bin/product-api
COPY wait.sh /bin/


RUN apt-get update && apt-get upgrade -y && \
    apt install -y net-tools bash curl unzip jq wget nano iputils-ping postgresql-client && \
    chmod +x /bin/product-api

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
    mv /tmp/consul /bin/consul && \
    wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v${ENVOY_VERSION}/envoy_${ENVOY_VERSION}_linux_amd64.zip && \
    unzip envoy_${ENVOY_VERSION}_linux_amd64.zip -d /tmp/ && \
    mv /tmp/envoy /bin/envoy && apt-get clean -y


CMD ["/bin/product-api"]