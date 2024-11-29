#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
savedargs=( "$@" )
config_opt=1
while [ $# -gt 0 ]; do
	if [[ $1 == "--config" || $1 == "-c" ]]; then
		config_opt=0
	fi
	shift
done
set -- "${savedargs[@]}"

if  [[ -n "${CONFIG_TEMPLATE}" && -n "${CONFIG_FILE}" ]]; then
	if [ -n "${TEMPLATE_SCRIPT}" ]; then
		echo "[$(date --iso-8601=s)] Running ${TEMPLATE_SCRIPT}${TEMPLATE_SCRIPT_ARGS:+ }${TEMPLATE_SCRIPT_ARGS} for building ${CONFIG_FILE} from ${CONFIG_TEMPLATE}." > /dev/stderr
		"$TEMPLATE_SCRIPT" "$TEMPLATE_SCRIPT_ARGS"
	fi
else
	config_opt=0
fi

if [ -n "${ROUTING_SCRIPT}" ]; then
	"${ROUTING_SCRIPT}"
fi

if [[ $config_opt -eq 1 ]]; then
	exec cp-lite --config "$CONFIG_FILE" "$@"
else
	exec cp-lite "$@"
fi
