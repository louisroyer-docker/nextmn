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
if [ -z "$HTTP_ADDRESS" ]; then
	echo "Missing mandatory environment variable (HTTP_ADDRESS)." > /dev/stderr
	exit 1
fi

awk \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v N4="${N4}" \
	-v HTTP_ADDRESS="${HTTP_ADDRESS}" \
	-v HTTP_PORT="${HTTP_PORT:-80}" \
	'{
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%HTTP_ADDRESS/, HTTP_ADDRESS);
		sub(/%HTTP_PORT/, HTTP_PORT);
		sub(/%N4/, N4);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
