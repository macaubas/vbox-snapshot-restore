#!/bin/bash
# Shell script created with the sole purpose of being invoked from the
# crontab. It'll suppress all messages it may generate, redirecting them
# to /dev/null. If you want to DEBUG and see the actual output, just set 
# debug=1.
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

#################
# CONFIGURATION #
#################
# Note: I'll assume that vbox-control.sh is located in the same folder. If that's not the case, please correct this bellow.
vbox_control=`pwd`"/vbox-control.sh"

# Set debug to 1 if you want to see the output.
debug=0

# So far, I've named all my snapshots to the same name. If you need to restore each
# virtualmachine to a different named snapshot, please submit a pull request: you're my
# guest.
snapshot="estado-inicial"

# Now name all the virtualmachines you'll need to revert to the snapshot every time you execute 
# this script. Please try to maintain the array integrity: while bash doesn't care about gaps in
# the array, you can be driven crazy if something goes wrong.
virtualMachines[0]="ubuntu_32bits"
virtualMachines[1]="win7_32bits"
virtualMachines[2]="win7_64bits"
virtualMachines[3]="WinXP_IE7"
virtualMachines[4]="WinXP_IE8"

##########################
####### THAT'S IT ########
##########################
# P.S.: really. Just go down below if you really know what
# you're doing.

function restore() {
	$vbox_control shutdown $1 $redirect
	$vbox_control revert $1 $2 $redirect
	$vbox_control start $1 $redirect
}

redirect="> /dev/null 2>&1"
if [ $debug -eq 1 ]; then
	redirect=""
fi

for virtualmachine in ${virtualMachines[@]}; do
	restore $virtualmachine $snapshot
done