#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p /opt/rt-n56u && \
ln -sf $WorkDir/toolchain-mipsel /opt/rt-n56u/toolchain-mipsel

[[ $UID == 0 ]] && {
	OptUSER=""
} || {
	# Add user and switch to the user
	{
		mkdir -p $(dirname $HOME)
		useradd -m -u $UID -d $HOME $USER
		passwd -d $USER
		gpasswd -a $USER sudo
		sed -i 's:%sudo\tALL=(ALL\:ALL) ALL:%sudo\tALL=NOPASSWD\: ALL:g' /etc/sudoers
	} &> /dev/null
	OptUSER="-u $USER"
}
exec sudo -s ${OptUSER} exec "$@"
