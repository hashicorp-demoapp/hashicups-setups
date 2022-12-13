FROM hashicorpdemoapp/frontend-nginx:v1.0.9 as builder

# We use Ubuntu to avoid the glibc compatibility complications of Alpine 
FROM ubuntu/nginx:1.18-20.04_beta

ENV ENVOY_VERSION=1.24.0
ENV CONSUL_VERSION=1.14.1

RUN apt-get update -y && apt-get upgrade -y && \
    apt install -y net-tools bash curl unzip sudo jq wget nano iputils-ping procps postgresql-client

RUN wget -q https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /tmp/ && \
    mv /tmp/consul /bin/consul && \
    wget https://github.com/nicholasjackson/envoy-binaries/releases/download/v${ENVOY_VERSION}/envoy_${ENVOY_VERSION}_linux_amd64.zip && \
    unzip envoy_${ENVOY_VERSION}_linux_amd64.zip -d /tmp/ && \
    mv /tmp/envoy /bin/envoy

COPY --from=builder /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the builder
COPY --from=builder /usr/share/nginx/html /usr/share/nginx/html
COPY --from=builder /app/entrypoint-nginx.sh /app/entrypoint-nginx.sh

EXPOSE 80

ENTRYPOINT ["/app/entrypoint-nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]