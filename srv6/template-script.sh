#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$HOOKS" ]; then
	echo "Missing mandatory environment variable (HOOKS)." > /dev/stderr
	exit 1
fi
if [ -z "$ENDPOINTS" ]; then
	echo "Missing mandatory environment variable (ENDPOINTS)." > /dev/stderr
	exit 1
fi
if [ -z "$LOCATOR" ]; then
	echo "Missing mandatory environment variable (LOCATOR)." > /dev/stderr
	exit 1
fi
if [ -z "$HTTP_ADDRESS" ]; then
	echo "Missing mandatory environment variable (HTTP_ADDRESS)." > /dev/stderr
	exit 1
fi
if [ -z "$CONTROLLER_URI" ]; then
	echo "Missing mandatory environment variable (CONTROLLER_URI)." > /dev/stderr
	exit 1
fi
if [ -z "$BACKBONE_IP" ]; then
	echo "Missing mandatory environment variable (BACKBONE_IP)." > /dev/stderr
	exit 1
fi

IFS=$'\n'
HOOKS_SUB=""
for HOOK in ${HOOKS}; do
	if [ -n "${HOOK}" ]; then
		HOOKS_SUB="${HOOKS_SUB}\n  ${HOOK}"
	fi
done

if [ -n "${HEADENDS}" ]; then
	HEADENDS_SUB="headends: "
	for HEADEND in ${HEADENDS}; do
		if [ -n "${HEADEND}" ]; then
			HEADENDS_SUB="${HEADENDS_SUB}\n  ${HEADEND}"
		fi
	done
fi

ENDPOINTS_SUB=""
for ENDPOINT in ${ENDPOINTS}; do
	if [ -n "${ENDPOINT}" ]; then
		ENDPOINTS_SUB="${ENDPOINTS_SUB}\n  ${ENDPOINT}"
	fi
done

if [ -n "$LINUX_HEADEND_SET_SOURCE_ADDRESS" ]; then
	LINUX_HEADEND_SET_SOURCE_ADDRESS_SUB="linux-headend-set-source-address: \"${LINUX_HEADEND_SET_SOURCE_ADDRESS}\""
fi
if [ -n "$IPV4_HEADEND_PREFIX" ]; then
	IPV4_HEADEND_PREFIX_SUB="ipv4-headend-prefix: \"${IPV4_HEADEND_PREFIX}\""
fi
if [ -n "$GTP4_HEADEND_PREFIX" ]; then
	GTP4_HEADEND_PREFIX_SUB="gtp4-headend-prefix: \"${GTP4_HEADEND_PREFIX}\""
fi

awk \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v HOOKS="${HOOKS_SUB}" \
	-v HEADENDS="${HEADENDS_SUB}" \
	-v ENDPOINTS="${ENDPOINTS_SUB}" \
	-v LOCATOR="${LOCATOR}" \
	-v IPV4_HEADEND_PREFIX="${IPV4_HEADEND_PREFIX_SUB}" \
	-v GTP4_HEADEND_PREFIX="${GTP4_HEADEND_PREFIX_SUB}" \
	-v LINUX_HEADEND_SET_SOURCE_ADDRESS="${LINUX_HEADEND_SET_SOURCE_ADDRESS_SUB}" \
	-v HTTP_ADDRESS="${HTTP_ADDRESS}" \
	-v HTTP_PORT="${HTTP_PORT:-80}" \
	-v CONTROLLER_URI="${CONTROLLER_URI}" \
	-v BACKBONE_IP="${BACKBONE_IP}" \
	'{
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%HOOKS/, HOOKS);
		sub(/%HEADENDS/, HEADENDS);
		sub(/%ENDPOINTS/, ENDPOINTS);
		sub(/%LOCATOR/, LOCATOR);
		sub(/%IPV4_HEADEND_PREFIX/,IPV4_HEADEND_PREFIX);
		sub(/%GTP4_HEADEND_PREFIX/,GTP4_HEADEND_PREFIX);
		sub(/%LINUX_HEADEND_SET_SOURCE_ADDRESS/, LINUX_HEADEND_SET_SOURCE_ADDRESS);
		sub(/%HTTP_ADDRESS/, HTTP_ADDRESS);
		sub(/%HTTP_PORT/, HTTP_PORT);
		sub(/%CONTROLLER_URI/, CONTROLLER_URI);
		sub(/%BACKBONE_IP/, BACKBONE_IP);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
