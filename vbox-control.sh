#!/bin/bash
# Shell script created with the sole purpose of reverting snapshots of
# VirtualBox VMs. Has a few extra commands to easy-up its usage,
# but please DO NOT USE IT AS A REPLACEMENT OF VBOXMANAGE.
#
# A lot of care have been taken to make exit and return codes right,
# for usage with crontab and other automation tools. If you ever change
# this script, please take extra care with this.
#
# Licensed under GNU/GPL:
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# Author: Igor Macaubas <igor@macaubas.com>
# http://github.com/macaubas

args=$*

vboxmanage=`whereis VBoxManage | cut -f1 -d " "`
vboxheadless=`whereis VBoxHeadless | cut -f1 -d " "`

# function: usage
# parameters: none
# Shows script usage
function usage() {
	echo "   \$ $0 usage:"
	echo "   \$ $0 list - list all VMs created in VirtualBox"
	echo "   \$ $0 shutdown <vm|uuid> - shutdown a specific VM"
	echo "   \$ $0 start <vm|uuid> - startup a specific VM"
	echo "   \$ $0 revert <vm|uuid> <snapshot_name> - revert the state of a specific VM"
	return 1
}

# function: list
# parameters: none
# Helper function. Lists all VMs under a VirtualBox installation
function list() {
	echo "Listing all VMs: (if empty none where found)"
	$vboxmanage list vms
	exit 0
}

# function: validadeEntry
# parameters:
#      - $1 = quantity of parameters that the function expects
#      - $2 = quantity of parameters effectively passed
# Function to validade the quantity of parameters passed
# If too few parameters are passed, invokes usage function
function validateEntry() {
	quantity=$1
	passed=$2
	if [ $quantity -ne $passed ]; then
		usage
		exit 1
	else 
		return 0
	fi	
}
# function: countParams
# parameters:
#      - $* = parameters
# Function to count the quantity of parameters passed
# Returns exactly this
function countParams() {
	params=$*
	index=0
	for param in $params; do
		let "index+=1"
	done
	return $index
}


# function: shutdown
# parameters: vm name OR vm UUID
# Function will stop the VM abruptly (not ACPI shutdown) 
function shutdown() {
	params_expected=1
	countParams $*
	qtd_params=$?
	validateEntry $params_expected $qtd_params
	$vboxmanage	controlvm $1 poweroff
	exit_code=$?
	if [ $exit_code -eq 0 ]; then
		return 0
	else
		exit 1
	fi
}

# function: start
# parameters: vm name OR vm UUID
# Function will start the VM (power on)
function start() {
	params_expected=1
	countParams $*
	qtd_params=$?
	validateEntry $params_expected $qtd_params	
	$vboxmanage startvm $1 --type headless 
	return 0
}

# function: revertSnapshot
# parameters:
#      - $1 = name of virtual machine
#      - $2 = name of snapshot to revert to
# Function will restore given snapshot to given virtualmachine
function revertSnapshot() {
	params_expected=2
	countParams $*
	qtd_params=$?
	validateEntry $params_expected $qtd_params	
	$vboxmanage snapshot $1 restore $2
	return 0
}

# Handles input and invokes all functions
case "$1" in
	list)
		list
		;;
	shutdown)
		shutdown $2
		;;
	start)
		start $2
		;;
	revert)
		revertSnapshot $2 $3
		;;
	*)
		usage
		;;
esac