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

# Set debug to 1 if you want to see the output.
debug=0


##########################
####### THAT'S IT ########
##########################
# P.S.: really. Just go down below if you really know what
# you're doing.

redirect="> /dev/null 2>&1"
if [ $debug -eq 1 ]; then
	redirect=""
fi

