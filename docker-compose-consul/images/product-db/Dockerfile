FROM postgres:13

ENV ENVOY_VERSION=1.18.3
ENV CONSUL_VERSION=1.10.4


COPY products.sql /docker-entrypoint-initdb.d/
COPY pg_hba.conf /tmp/


RUN apt-get update -y && apt-get upgrade -y && \
apt install -y net-tools bash curl unzip sudo jq wget nano iputils-ping procps postgresql-client && \
chmod a+r /docker-entrypoint-initdb.d/* && \
rm -rf /var/lib/apt/lists/* && \
chmod a+r /docker-entrypoint-initdb.d/

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/consul /bin/consul && \
wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v${ENVOY_VERSION}/envoy_${ENVOY_VERSION}_linux_amd64.zip && \
unzip envoy_${ENVOY_VERSION}_linux_amd64.zip -d /tmp/ && \
mv /tmp/envoy /bin/envoy && \
# Removing postgress password so sudo can be used to start Consul
usermod -aG sudo postgres && \
sed -i '$ d' /etc/shadow && \
echo "postgres::18898::::::" >> /etc/shadow