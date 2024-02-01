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

IFS=$'\n'
HOOKS_SUB=""
for HOOKS in ${HOOKS}; do
	if [ -n "${HOOK}" ]; then
		HOOKS_SUB="${HOOKS_SUB}\n  ${HOOK}"
	fi
done

if [ -n "${HEADENDS}" ]; then
	HEADENDS_SUB="headends: "
	for HEADENDS in ${HEADENDS}; do
		if [ -n "${HEADEND}" ]; then
			HEADENDS_SUB="${HEADENDS_SUB}\n  ${HEADEND}"
		fi
	done
fi

ENDPOINTS_SUB=""
for ENDPOINTS in ${ENDPOINTS}; do
	if [ -n "${ENDPOINT}" ]; then
		ENDPOINTS_SUB="${ENDPOINTS_SUB}\n  ${ENDPOINT}"
	fi
done

if [ -n "$LINUX_HEADEND_SET_SOURCE_ADDRESS" ]; then
	LINUX_HEADEND_SET_SOURCE_ADDRESS_SUB="linux-headend-set-source-address: ${LINUX_HEADEND_SET_SOURCE_ADDRESS}"
fi
if [ -n "$IPV4_HEADEND_PREFIX" ]; then
	IPV4_HEADEND_PREFIX_SUB="ipv4-headend-prefix: ${IPV4_HEADEND_PREFIX}"
fi

awk \
	-v DEBUG="${DEBUG:-false}" \
	-v HOOKS="${HOOKS_SUB}" \
	-v HEADENDS="${HEADENDS_SUB}" \
	-v ENDPOINTS="${ENDPOINTS_SUB}" \
	-v LOCATOR="${LOCATOR}" \
	-v IPV4_HEADEND_PREFIX="${IPV4_HEADEND_PREFIX_SUB}" \
	-v LINUX_HEADEND_SET_SOURCE_ADDRESS="${LINUX_HEADEND_SET_SOURCE_ADDRESS_SUB}" \
	'{
		sub(/%DEBUG/, DEBUG);
		sub(/%HOOKS/, HOOKS);
		sub(/%HEADENDS/, HEADENDS);
		sub(/%ENDPOINTS/, ENDPOINTS);
		sub(/%LOCATOR/, LOCATOR);
		sub(/%IPV4_HEADEND_PREFIX/,IPV4_HEADEND_PREFIX);
		sub(/%LINUX_HEADEND_SET_SOURCE_ADDRESS/, LINUX_HEADEND_SET_SOURCE_ADDRESS);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
