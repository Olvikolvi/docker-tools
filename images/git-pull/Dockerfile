FROM alpine:3.7
MAINTAINER Mikko Lampikoski <mikko@lampikoski.com>
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license=GPL-2.0 \
    org.label-schema.name=git-pull \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/lampikoski/docker-tools

ENV DEST=. \
    GIT_COMMIT=master \
    GIT_HOST=github.com \
    GIT_REPO=uri \
    INTERVAL=0

RUN apk add --no-cache --update git openssh-client

VOLUME /git

COPY entrypoint.sh /root/
ENTRYPOINT /root/entrypoint.sh
