#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$HTTP_ADDRESS" ]; then
	echo "Missing mandatory environment variable (HTTP_ADDRESS)." > /dev/stderr
	exit 1
fi
if [ -z "$RAN" ]; then
	echo "Missing mandatory environment variable (RAN)." > /dev/stderr
	exit 1
fi

IFS=$'\n'

RAN_SUB=""
for R in ${RAN}; do
	if [ -n "${R}" ]; then
		RAN_SUB="${RAN_SUB}\n  ${R}"
	fi
done

awk \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v RAN="${RAN_SUB}" \
	-v HTTP_PORT="${HTTP_PORT:-80}" \
	-v HTTP_ADDRESS="${HTTP_ADDRESS}" \
	'{
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%RAN/, RAN);
		sub(/%HTTP_PORT/, HTTP_PORT);
		sub(/%HTTP_ADDRESS/, HTTP_ADDRESS);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
