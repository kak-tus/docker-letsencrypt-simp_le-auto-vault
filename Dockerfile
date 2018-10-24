FROM alpine:3.8 AS build

ENV \
  VAULT_VERSION=0.11.4 \
  VAULT_SHA256=3e44826ffcf3756a72d6802d96ea244e605dad362ece27d5c8f8839fb69a7079

RUN \
  apk add --no-cache \
    curl \
    unzip \
  \
  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault_${VAULT_VERSION}_linux_amd64.zip \
  && echo -n "$VAULT_SHA256  vault_${VAULT_VERSION}_linux_amd64.zip" | sha256sum -c - \
  && unzip vault_${VAULT_VERSION}_linux_amd64.zip \
  && rm vault_${VAULT_VERSION}_linux_amd64.zip

FROM alpine:3.8

ENV \
  CERTS_DIR= \
  VAULT_ADDR= \
  VAULT_TOKEN= \
  \
  VAULT_PATH=secret/certificates

COPY store /etc/periodic/15min/store
COPY renew /etc/periodic/weekly/renew
COPY --from=build /usr/local/bin/vault /usr/local/bin/vault

CMD ["crond", "-f"]
