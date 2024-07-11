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
if [ -z "$GTPU_ENTITIES_LIST" ]; then
	echo "Missing mandatory environment variable (GTPU_ENTITIES_LIST)." > /dev/stderr
	exit 1
fi
# For future: https://github.com/nextmn/upf/issues/30
#if [ -z "$IF_LIST" ]; then
#	echo "Missing mandatory environment variable (IF_LIST)." > /dev/stderr
#	exit 1
#fi

IFS=$'\n'

DNN_LIST_SUB=""
for DNN in ${DNN_LIST}; do
	if [ -n "${DNN}" ]; then
		DNN_LIST_SUB="${DNN_LIST_SUB}\n  ${DNN}"
	fi
done
# For future: https://github.com/nextmn/upf/issues/30
#IF_LIST_SUB=""
#for INTERFACE in ${IF_LIST}; do
#	if [ -n "${INTERFACE}" ]; then
#		IF_LIST_SUB="${IF_LIST_SUB}\n    ${INTERFACE}"
#	fi
#done
for GTPU_ENTITIES in ${GTPU_ENTITIES_LIST}; do
	if [ -n "${GTPU_ENTITIES}" ]; then
		GTPU_ENTITIES_LIST_SUB="${GTPU_ENTITIES_LIST_SUB}\n  ${GTPU_ENTITIES}"
	fi
done

awk \
	-v N4="${N4}" \
	-v DNN_LIST="${DNN_LIST_SUB}" \
	-v GTPU_ENTITIES_LIST="${GTPU_ENTITIES_LIST_SUB}" \
	'{
		sub(/%N4/, N4);
		sub(/%DNN_LIST/, DNN_LIST);
		sub(/%GTPU_ENTITIES_LIST/, GTPU_ENTITIES_LIST);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
