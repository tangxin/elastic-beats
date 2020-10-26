ARG DISTROLESS

##
FROM alpine:3.12 as downloader
ARG VERSION
RUN apk add --no-cache curl ca-certificates
WORKDIR /root/
RUN set -ex; curl -o {{ BEAT_BIN }}.yml -sfSL https://raw.githubusercontent.com/elastic/beats/v${VERSION}/{{ BEAT_BIN }}/{{ BEAT_BIN }}.reference.yml

## 
FROM ${DISTROLESS}
ARG VERSION
ARG TARGETOS
ARG TARGETARCH 

WORKDIR /usr/share/{{ BEAT_BIN }}

ENV PATH /usr/share/{{ BEAT_BIN }}:$PATH
ENV ENV ELASTIC_CONTAINER=true

COPY out/{{ BEAT_BIN }}-v${VERSION}-${TARGETOS}-${TARGETARCH} /usr/share/{{ BEAT_BIN }}/{{ BEAT_BIN }}
COPY --from=downloader /root/{{ BEAT_BIN }}.yml {{ BEAT_BIN }}.yml

ENTRYPOINT [ "{{ BEAT_BIN }}" ]
CMD ["--environment", "container"]
