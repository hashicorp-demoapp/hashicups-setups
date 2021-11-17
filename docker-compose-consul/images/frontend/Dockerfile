FROM hashicorpdemoapp/frontend:v0.0.7 as base

FROM nginx:1.21.1

ENV ENVOY_VERSION=1.18.3
ENV CONSUL_VERSION=1.10.4

COPY --from=base /usr/share/nginx/html /usr/share/nginx/html

RUN apt-get update -y && apt-get upgrade -y && \
apt install -y net-tools bash curl unzip sudo jq wget nano iputils-ping procps postgresql-client

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/consul /bin/consul && \
wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v${ENVOY_VERSION}/envoy_${ENVOY_VERSION}_linux_amd64.zip && \
unzip envoy_${ENVOY_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/envoy /bin/envoy 

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]