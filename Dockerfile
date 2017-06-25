FROM alpine:3.6

ENV VAULT_VERSION=0.7.3
ENV VAULT_SHA256=2822164d5dd347debae8b3370f73f9564a037fc18e9adcabca5907201e5aab45

RUN \
  apk add --no-cache --virtual .build-deps \
    curl \
    unzip \

  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault_${VAULT_VERSION}_linux_amd64.zip \
  && echo -n "$VAULT_SHA256  vault_${VAULT_VERSION}_linux_amd64.zip" | sha256sum -c - \
  && unzip vault_${VAULT_VERSION}_linux_amd64.zip \
  && rm vault_${VAULT_VERSION}_linux_amd64.zip \

  && apk del .build-deps

ENV CERTS_DIR=
ENV VAULT_ADDR=
ENV VAULT_TOKEN=

ENV VAULT_PATH=secret/certificates

COPY store /etc/periodic/hourly/store

CMD ["crond", "-f"]
