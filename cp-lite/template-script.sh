#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$N4" ]; then
	echo "Missing mandatory environment variable (N4)." > /dev/stderr
	exit 1
fi
if [ -z "$SLICES" ]; then
	echo "Missing mandatory environment variable (SLICES)." > /dev/stderr
	exit 1
fi
if [ -z "$AREAS" ]; then
	echo "Missing mandatory environment variable (AREAS)." > /dev/stderr
	exit 1
fi
if [ -z "$HTTP_ADDRESS" ]; then
	echo "Missing mandatory environment variable (HTTP_ADDRESS)." > /dev/stderr
	exit 1
fi

IFS=$'\n'

SLICES_SUB=""
for S in ${SLICES}; do
	if [ -n "${S}" ]; then
		SLICES_SUB="${SLICES_SUB}\n  ${S}"
	fi
done

AREAS_SUB=""
for S in ${AREAS}; do
	if [ -n "${S}" ]; then
		AREAS_SUB="${AREAS_SUB}\n  ${S}"
	fi
done

awk \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v HTTP_PORT="${HTTP_PORT:-80}" \
	-v HTTP_ADDRESS="${HTTP_ADDRESS}" \
	-v SLICES="${SLICES_SUB}" \
	-v AREAS="${AREAS_SUB}" \
	-v N4="${N4}" \
	-v SLICES="${SLICES_SUB}" \
	'{
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%HTTP_PORT/, HTTP_PORT);
		sub(/%HTTP_ADDRESS/, HTTP_ADDRESS);
		sub(/%N4/, N4);
		sub(/%SLICES/, SLICES);
		sub(/%AREAS/, AREAS);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
