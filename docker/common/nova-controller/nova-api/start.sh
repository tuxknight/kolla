#!/bin/bash
set -o errexit

CMD="/usr/bin/nova-api"
ARGS=""

# Loading common functions.
source /opt/kolla/kolla-common.sh

# Config-internal script exec out of this function, it does not return here.
set_configs

exec $CMD $ARGS
