FROM hashicorpdemoapp/payments:latest as base

FROM ubuntu:20.04

ENV ENVOY_VERSION=1.18.3
ENV CONSUL_VERSION=1.10.4


COPY --from=base spring-boot-payments-0.0.12.jar /bin/spring-boot-payments-0.0.12.jar

RUN apt-get update && apt-get upgrade -y && \
apt install -y net-tools bash unzip jq wget nano default-jre iputils-ping && \
chmod +x /bin/spring-boot-payments-0.0.12.jar && \
rm -rf /var/lib/apt/lists/*

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/consul /bin/consul && \
wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v${ENVOY_VERSION}/envoy_${ENVOY_VERSION}_linux_amd64.zip && \
unzip envoy_${ENVOY_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/envoy /bin/envoy 


CMD ["java", "-jar", "/bin/spring-boot-payments-0.0.12.jar"]
