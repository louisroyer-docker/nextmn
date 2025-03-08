# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

FROM golang:1.23 AS builder
ARG COMMIT=380b60757f1957bee10bbc1f4f909caef440ac23
RUN : ${COMMIT:? Missing build-arg COMMIT.} && go install github.com/nextmn/cp-lite@${COMMIT}


FROM louisroyer/base-irit:latest

LABEL maintainer="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.authors="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.source="https://github.com/louisroyer-docker/nextmn"

# Used to disable caching of next steps, if not build since 1 day,
# allowing to search and apply security upgrades
ARG BUILD_DATE=""

RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    docker-setup \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/cp-lite /usr/local/bin/cp-lite
COPY ./*.sh /usr/local/bin/
COPY ./template-cp-lite.yaml /usr/local/share/nextmn/
ENV ROUTING_SCRIPT="docker-setup" \
    ONESHOT="true" \
    TEMPLATE_SCRIPT="template-script.sh" \
    TEMPLATE_SCRIPT_ARGS="" \
    CONFIG_FILE="/etc/nextmn/cp-lite.yaml" \
    CONFIG_TEMPLATE="/usr/local/share/nextmn/template-cp-lite.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]

HEALTHCHECK --interval=1m --timeout=1s --retries=3 --start-period=5s --start-interval=100ms \
CMD ["entrypoint.sh", "healthcheck"]
