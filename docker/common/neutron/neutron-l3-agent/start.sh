#!/bin/bash
set -o errexit

CMD="/usr/bin/neutron-l3-agent"
ARGS="--config-file /etc/neutron/l3_agent.ini --config-file /etc/neutron/fwaas_driver.ini --config-dir /etc/neutron"

# Loading common functions.
source /opt/kolla/kolla-common.sh

# Override set_configs() here because it doesn't work for fat containers like
# this one.
set_configs() {
    case $KOLLA_CONFIG_STRATEGY in
        CONFIG_INTERNAL)
            # exec is intentional to preserve existing behaviour
            exec /opt/kolla/neutron-l3-agent/config-internal.sh
            ;;
        CONFIG_EXTERNAL_COPY_ALWAYS)
            source /opt/kolla/neutron-l3-agent/config-exernal.sh
            ;;
        CONFIG_EXTERNAL_COPY_ONCE)
            if [[ -f /configured-l3 ]]; then
                echo 'INFO - Neutron-l3 has already been configured; Refusing to copy new configs'
                return
            fi
            source /opt/kolla/neutron-l3-agent/config-exernal.sh
            touch /configured-l3
            ;;

        *)
            echo '$KOLLA_CONFIG_STRATEGY is not set properly'
            exit 1
            ;;
    esac
}

# Config-internal script exec out of this function, it does not return here.
set_configs

exec $CMD $ARGS
