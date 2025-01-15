# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.22 AS builder
ARG COMMIT=v0.0.25
RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install github.com/nextmn/srv6@${COMMIT} \
      && find /go/pkg/mod/github.com/nextmn -iname 'srv6@*' -type d -exec ln -s {} /configuration \;


FROM louisroyer/base-irit:latest

LABEL maintainer="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.authors="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.source="https://github.com/louisroyer-docker/nextmn"

# Used to disable caching of next steps, if not build since 1 day,
# allowing to search and apply security upgrades
ARG BUILD_DATE=""

RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iptables \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/srv6 /usr/local/bin/srv6
COPY --from=builder /configuration/etc/iproute2/rt_tables.d/nextmn.conf /etc/iproute2/rt_tables.d/nextmn.conf
COPY --from=builder /configuration/etc/iproute2/rt_protos.d/nextmn.conf /etc/iproute2/rt_protos.d/nextmn.conf
COPY ./*.sh /usr/local/bin/
COPY ./template-srv6.yaml /usr/local/share/nextmn/
ENV TEMPLATE_SCRIPT="template-script.sh" \
    TEMPLATE_SCRIPT_ARGS="" \
    CONFIG_FILE="/etc/nextmn/srv6.yaml" \
    CONFIG_TEMPLATE="/usr/local/share/nextmn/template-srv6.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]

HEALTHCHECK --interval=1m --timeout=1s --retries=3 --start-period=5s --start-interval=100ms \
CMD ["entrypoint.sh", "healthcheck"]
