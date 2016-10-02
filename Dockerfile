FROM alpine:3.4

ENV CERTS_DIR=
ENV VAULT_ADDR=
ENV VAULT_TOKEN=

ENV VAULT_PATH=secret/certificates

COPY store /etc/periodic/hourly/store
COPY vault_0.6.1_SHA256SUMS /usr/local/bin/vault_0.6.1_SHA256SUMS

RUN apk add --no-cache curl bash \

  && cd /usr/local/bin \

  && curl -L https://releases.hashicorp.com/vault/0.6.1/vault_0.6.1_linux_amd64.zip -o vault_0.6.1_linux_amd64.zip \
  && sha256sum -c vault_0.6.1_SHA256SUMS \
  && unzip vault_0.6.1_linux_amd64.zip \
  && rm vault_0.6.1_linux_amd64.zip vault_0.6.1_SHA256SUMS \

  && apk del curl

CMD crond -f
