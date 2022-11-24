FROM ubuntu:20.04

ENV ENVOY_VERSION=1.20.1
ENV CONSUL_VERSION=1.11.4

RUN apt-get update && apt-get upgrade -y && \
apt install -y net-tools bash unzip jq wget nano default-jre iputils-ping && \
rm -rf /var/lib/apt/lists/*

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/consul /bin/consul

WORKDIR certificates
RUN consul tls ca create && \
consul tls cert create -server -dc dc1 -additional-dnsname="*.dc2.consul" -additional-dnsname="consul_server_0" && \
consul tls cert create -server -dc dc1 -additional-dnsname="*.dc2.consul" -additional-dnsname="consul_server_1" && \
consul tls cert create -server -dc dc1 -additional-dnsname="*.dc2.consul" -additional-dnsname="consul_server_2" && \
consul tls cert create -server -dc dc2 -additional-dnsname="*.dc1.consul" -additional-dnsname="consul_secondary_server_1" && \
consul tls cert create -server -dc dc2 -additional-dnsname="*.dc1.consul" -additional-dnsname="consul_secondary_server_1" && \
consul tls cert create -server -dc dc2 -additional-dnsname="*.dc1.consul" -additional-dnsname="consul_secondary_server_1" && \
consul tls cert create -client -dc dc1 && \
consul tls cert create -client -dc dc2

ENTRYPOINT ["/bin/bash", "-l", "-c"]
