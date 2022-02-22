FROM hashicorpdemoapp/frontend:v1.0.1 as builder

FROM ubuntu:20.04

ENV ENVOY_VERSION=1.20.1
ENV CONSUL_VERSION=1.11.3

RUN apt-get update -y && apt-get upgrade -y && \
    apt install -y net-tools bash curl unzip sudo jq wget nano iputils-ping procps postgresql-client

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
    mv /tmp/consul /bin/consul && \
    wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v${ENVOY_VERSION}/envoy_${ENVOY_VERSION}_linux_amd64.zip && \
    unzip envoy_${ENVOY_VERSION}_linux_amd64.zip -d /tmp/ && \
    mv /tmp/envoy /bin/envoy && curl -sL https://deb.nodesource.com/setup_16.x | bash && apt install nodejs


EXPOSE 3000

COPY --from=builder /app /app

CMD ["/app/node_modules/.bin/next", "start"]