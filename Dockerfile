ARG VERSION
ARG BEAT
FROM elastic/${BEAT}:${VERSION} as src
RUN rm -f ${BEAT}

## 
FROM debian:buster-slim
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG BEAT

COPY --from=src /usr/share/${BEAT} /usr/share/${BEAT}
COPY --from=src /usr/local/bin/docker-entrypoint /usr/local/bin/docker-entrypoint
COPY out/${BEAT}-v${VERSION}-${TARGETOS}-${TARGETARCH} /usr/share/${BEAT}/${BEAT}

ENV PATH /usr/share/${BEAT}:$PATH
ENV ENV ELASTIC_CONTAINER=true
WORKDIR /usr/share/${BEAT}

RUN groupadd --gid 1000 ${BEAT} \
    && useradd -M --uid 1000 --gid 1000 --groups 0 --home /usr/share/${BEAT} ${BEAT}
USER ${BEAT}

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint" ]
CMD ["--environment", "container"]

