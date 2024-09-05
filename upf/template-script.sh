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
if [ -z "$DNN_LIST" ]; then
	echo "Missing mandatory environment variable (DNN_LIST)." > /dev/stderr
	exit 1
fi
if [ -z "$IF_LIST" ]; then
	echo "Missing mandatory environment variable (IF_LIST)." > /dev/stderr
	exit 1
fi

IFS=$'\n'

DNN_LIST_SUB=""
for DNN in ${DNN_LIST}; do
	if [ -n "${DNN}" ]; then
		DNN_LIST_SUB="${DNN_LIST_SUB}\n  ${DNN}"
	fi
done
IF_LIST_SUB=""
for INTERFACE in ${IF_LIST}; do
	if [ -n "${INTERFACE}" ]; then
		IF_LIST_SUB="${IF_LIST_SUB}\n    ${INTERFACE}"
	fi
done

awk \
	-v LOG_LEVEL="${LOG_LEVEL:-info}" \
	-v N4="${N4}" \
	-v DNN_LIST="${DNN_LIST_SUB}" \
	-v IF_LIST="${IF_LIST_SUB}" \
	'{
		sub(/%LOG_LEVEL/, LOG_LEVEL);
		sub(/%N4/, N4);
		sub(/%DNN_LIST/, DNN_LIST);
		sub(/%IF_LIST/, IF_LIST);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
