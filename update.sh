#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check dependencies
assert_dependency "jq"
assert_dependency "curl"

# Alpine Linux
update_image "amd64/alpine" "Alpine Linux" "false" "\d{8}"

# Packages
IMG_ARCH="x86_64"
BASE_PKG_URL="https://pkgs.alpinelinux.org/package/edge"
update_pkg "boinc" "BOINC Client" "true" "$BASE_PKG_URL/testing/$IMG_ARCH" "(\d+\.)+\d+-r\d+"
update_pkg "ca-certificates" "CA-Certificates" "false" "$BASE_PKG_URL/main/$IMG_ARCH" "\d{8}-r\d+"

if ! updates_available; then
	#echo "No updates available."
	exit 0
fi

# Perform modifications
if [ "${1-}" = "--noconfirm" ] || confirm_action "Save changes?"; then
	save_changes

	if [ "${1-}" = "--noconfirm" ] || confirm_action "Commit changes?"; then
		commit_changes
	fi
fi