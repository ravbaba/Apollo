#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.

source "${APOLLO_ROOT}/bootstrap/lib/ovpn-bootstrap.sh"
source "${APOLLO_ROOT}/bootstrap/lib/bastion-ssh-config.sh"

apollo_down() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform destroy -var "access_key=${TF_VAR_access_key}" \
      -var "key_file=${TF_VAR_key_file}" \
      -var "region=${TF_VAR_region}"
  popd
}
