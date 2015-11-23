#!/bin/bash

ansible_ssh_config() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    export APOLLO_bastion_ip=$( terraform output bastion.ip )

    # Virtual private cloud CIDR IP.
    ip=$( terraform output vpc_cidr_block.ip )
    export APOLLO_network_identifier=$( get_network_identifier "${ip}" )

    cat <<EOF > ssh.config
  Host bastion $APOLLO_bastion_ip
    StrictHostKeyChecking  no
    User                   ubuntu
    HostName               $APOLLO_bastion_ip
    ProxyCommand           none
    IdentityFile           $TF_VAR_private_key_file
    BatchMode              yes
    PasswordAuthentication no
    UserKnownHostsFile     /dev/null
  Host $APOLLO_network_identifier.*
    StrictHostKeyChecking  no
    ServerAliveInterval    120
    TCPKeepAlive           yes
    ProxyCommand           ssh -q -A -F $(pwd)/ssh.config ubuntu@$APOLLO_bastion_ip nc %h %p
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         30m
    User                   ubuntu
    IdentityFile           $TF_VAR_private_key_file
    UserKnownHostsFile     /dev/null
EOF
  popd
}
