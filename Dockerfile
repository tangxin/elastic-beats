ARG BEAT
ARG VERSION
FROM docker.elastic.co/beats/${BEAT}:${VERSION} as src
USER root
ARG BEAT
RUN rm -f /usr/share/${BEAT}/${BEAT}


FROM debian:buster-slim
ARG BEAT
ARG VERSION
ARG TARGETOS
ARG TARGETARCH

COPY --from=src /usr/share/${BEAT} /usr/share/${BEAT}
COPY --from=src /usr/local/bin/docker-entrypoint /usr/local/bin/docker-entrypoint
COPY out/${BEAT}-v${VERSION}-${TARGETOS}-${TARGETARCH} /usr/share/${BEAT}/${BEAT}

WORKDIR /usr/share/${BEAT}
ENV PATH=/usr/share/${BEAT}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["-environment", "container"]
