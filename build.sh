#!/usr/bin/env bash

set -e

follow_link() {
  FILE="$1"
  while [ -h "$FILE" ]; do
    # On Mac OS, readlink -f doesn't work.
    FILE="$(readlink "$FILE")"
  done
  echo "$FILE"
}

SCRIPT_PATH=$(realpath "$(dirname "$(follow_link "$0")")")
CONFIG_PATH=$(realpath "${1:-${SCRIPT_PATH}/config}")
INPUT_PATH="$SCRIPT_PATH"/builds/linux/ubuntu/23.04/

echo "Building a Ubuntu Server 23.04 Template for VMware vSphere..."

### Initialize HashiCorp Packer and required plugins. ###
echo "Initializing HashiCorp Packer and required plugins..."
packer init "$INPUT_PATH"

### Start the Build. ###
echo "Starting the build...."
packer build -force \
  -var-file="$CONFIG_PATH/vsphere.pkrvars.hcl" \
  -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
  -var-file="$CONFIG_PATH/ansible.pkrvars.hcl" \
  -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
  "$INPUT_PATH"

### All done. ###
echo "Done."
