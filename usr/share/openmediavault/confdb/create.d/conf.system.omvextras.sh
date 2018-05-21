#!/bin/bash
#
# @license   http://www.gnu.org/licenses/gpl.html GPL Version 3
# @author    Volker Theile <volker.theile@openmediavault.org>
# @author    OpenMediaVault Plugin Developers <plugins@omv-extras.org>
# @copyright Copyright (c) 2009-2013 Volker Theile
# @copyright Copyright (c) 2013-2018 OpenMediaVault Plugin Developers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

set -e

. /usr/share/openmediavault/scripts/helper-functions

if ! omv_config_exists "/config/system/omvextras"; then
    echo "Initialize configuration"
    default_repos=$(cat /etc/omvextras/default_repos.xml | sed -e 's/^[ \t]*//' | tr '\n' ' ')
    omv_config_add_node_data "/config/system" "omvextras" "${default_repos}"
fi

# change plex repo based on architecture
if [[ $(arch) == arm* ]]; then
    plex_repo=""
else
    plex_repo="https://downloads.plex.tv/repo/deb/ ./public main"
fi
omv_config_update "/config/system/omvextras/repos/repo[uuid='eafd450c-0e48-11e6-8349-000c290ea003']/repo2" "${plex_repo}"

# disable grub submenus on systems that use grub
if [ -f /usr/sbin/update-grub ]; then
    omv-grubiso disablesubmenu
fi

# write list file
omv-mkconf apt

exit 0
