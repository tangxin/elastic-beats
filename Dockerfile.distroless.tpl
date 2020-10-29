ARG DISTROLESS

##
FROM alpine:3.12 as downloader
RUN apk add --no-cache curl ca-certificates
WORKDIR /root/
ARG VERSION
ARG BEAT
RUN set -ex; curl -o ${BEAT}.yml -sfSL https://raw.githubusercontent.com/elastic/beats/v${VERSION}/${BEAT}/${BEAT}.reference.yml

## 
FROM ${DISTROLESS}
ARG TARGETOS
ARG TARGETARCH 
ARG VERSION
ARG BEAT

WORKDIR /usr/share/${BEAT}

ENV PATH /usr/share/${BEAT}:$PATH
ENV ENV ELASTIC_CONTAINER=true

COPY out/${BEAT}-v${VERSION}-${TARGETOS}-${TARGETARCH} /usr/share/${BEAT}/${BEAT}
COPY --from=downloader /root/${BEAT}.yml ${BEAT}.yml

ENTRYPOINT [ "{{ BEAT }}" ]
CMD ["--environment", "container"]
