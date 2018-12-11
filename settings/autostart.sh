# 
# This file originates from Kite's Circuit Sword control board project.
# Author: Kite (Giles Burgess)
# 
# THIS HEADER MUST REMAIN WITH THIS FILE AT ALL TIMES
#
# This firmware is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This firmware is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this repo. If not, see <http://www.gnu.org/licenses/>.
#

# This file exists in '/opt/retropie/configs/all/autostart.sh'

# Load config file and action
CONFIGFILE="/boot/config-cs.txt"
FIRSTBOOT="/boot/firstboot.txt"
if [ -f $CONFIGFILE ]; then
  
  source $CONFIGFILE
  
  if [[ -n "$STARTUPEXEC" ]] ; then
    echo "Starting STARTUPEXEC.."
    $STARTUPEXEC &
  fi
  
  if [ ! -f $FIRSTBOOT ]; then
    speaker-test -l1 --test=sine -f30
    sudo alsactl restore
    amixer sset PCM "20%"
    sudo touch $FIRSTBOOT
  fi
  
  if [[ "$MODE" == "TESTER" && -n "$TESTER" ]] ; then
    echo "Starting TESTER.."
    python $TESTER
  elif [ "$MODE" == "SHELL" ] ; then
    echo "Starting SHELL.."
    exit 0
  else
    echo "Starting EMULATIONSTATION.."
    emulationstation #auto
  fi
  
else
  
  echo "Starting EMULATIONSTATION.."
  emulationstation #auto
  
fi
