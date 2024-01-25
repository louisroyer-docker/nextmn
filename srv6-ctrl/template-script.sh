#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$N6" ]; then
	echo "Missing mandatory environment variable (N6)." > /dev/stderr
	exit 1
fi

awk \
	-v N6="${N6}" \
	'{
		sub(/%N6/, N6);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
