#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
source "${APOLLO_ROOT}/bootstrap/lib/ovpn-bootstrap.sh"
source "${APOLLO_ROOT}/bootstrap/lib/bastion-ssh-config.sh"

ssh_thumbprint() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    if [ ! -f "ssh_thumbprint" ]; then
      touch ssh_thumbprint
    fi
  popd
}

apollo_down() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform destroy -var "azure_settings_file=${TF_VAR_azure_settings_file}" \
      -var "region=${TF_VAR_region}"
  popd
}
