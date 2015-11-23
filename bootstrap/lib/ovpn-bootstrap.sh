#!/bin/bash

function set_vpn() {
  while true; do
  read -p "Do you want to start the VPN and setup a connection now (y/n)?" yn
    case $yn in
        [Yy]* ) ovpn_start;ovpn_client_config; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
  done
}

ovpn_start() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    echo "... initialising VPN setup" >&2
    /bin/sh -x bin/ovpn-init
    /bin/sh -x bin/ovpn-start
  popd
}

ovpn_client_config() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    echo "... creating VPN client configuration" >&2
    /bin/sh -x bin/ovpn-new-client "${TF_VAR_user}"
    /bin/sh -x bin/ovpn-client-config "${TF_VAR_user}"

    # We need to sed the .ovpn file to replace the correct IP address, because we are getting the
    # instance IP address not the elastic IP address in the downloaded file.
    bastion_ip=$(terraform output bastion.ip)
    /usr/bin/env sed -i -e "s/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/${bastion_ip}/g" "${TF_VAR_user-apollo.ovpn}"

    /usr/bin/open "${TF_VAR_user-apollo.ovpn}"
    # Display a prompt to tell the user to connect in their VPN client,
    # and pause/wait for them to connect.
    while true; do
    read -p "Your VPN client should be open. Please now connect to the VPN using your VPN client.
      Once connected hit y to open the web interface or n to exit (y/n)?" yn
      case $yn in
          [Yy]* ) popd;open_urls; break;;
          [Nn]* ) popd;exit;;
          * ) echo "Please answer y or n.";;
      esac
    done
}
