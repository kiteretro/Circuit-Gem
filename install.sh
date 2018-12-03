#!/bin/bash

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

if [ "$EUID" -ne 0 ]
  then echo "Please run as root (sudo)"
  exit 1
fi

if [ $# == 0 ] || [ $# == 3 ] ; then
  echo "Usage: ./<cmd> YES [branch] [fat32 root] [ext4 root]"
  exit 1
fi

#####################################################################
# Vars

if [[ $3 != "" ]] ; then
  DESTBOOT=$3
else
  DESTBOOT="/boot"
fi

if [[ $4 != "" ]] ; then
  DEST=$4
else
  DEST=""
fi

GITHUBPROJECT="Circuit-Gem"
GITHUBURL="https://github.com/kiteretro/$GITHUBPROJECT"
PIHOMEDIR="$DEST/home/pi"
BINDIR="$PIHOMEDIR/$GITHUBPROJECT"
USER="pi"

if [[ $2 != "" ]] ; then
  BRANCH=$2
else
  BRANCH="master"
fi

#####################################################################
# Functions
execute() { #STRING
  if [ $# != 1 ] ; then
    echo "ERROR: No args passed"
    exit 1
  fi
  cmd=$1
  
  echo "[*] EXECUTE: [$cmd]"
  eval "$cmd"
  ret=$?
  
  if [ $ret != 0 ] ; then
    echo "ERROR: Command exited with [$ret]"
    exit 1
  fi
  
  return 0
}

exists() { #FILE
  if [ $# != 1 ] ; then
    echo "ERROR: No args passed"
    exit 1
  fi
  
  file=$1
  
  if [ -f $file ]; then
    echo "[i] FILE: [$file] exists."
    return 0
  else
    echo "[i] FILE: [$file] does not exist."
    return 1
  fi
}

#####################################################################
# LOGIC!
echo "INSTALLING.."

# Checkout code if not already done so
if ! exists "$BINDIR/LICENSE" ; then
  execute "git clone --recursive --depth 1 --branch $BRANCH $GITHUBURL $BINDIR"
fi
execute "chown -R $USER:$USER $BINDIR"

#####################################################################
# Copy required to /boot

# Config.txt bits
if ! exists "$DESTBOOT/config_ORIGINAL.txt" ; then
  execute "cp $DESTBOOT/config.txt $DESTBOOT/config_ORIGINAL.txt"
  execute "cp $BINDIR/settings/config.txt $DESTBOOT/config.txt"
  execute "cp $BINDIR/settings/config-cs.txt $DESTBOOT/config-cs.txt"
fi

# Cmdline.txt bits
if ! exists "$DESTBOOT/cmdline_ORIGINAL.txt" ; then
  execute "cp $DESTBOOT/cmdline.txt $DESTBOOT/cmdline_ORIGINAL.txt"
  execute "cp $BINDIR/settings/cmdline.txt $DESTBOOT/cmdline_ORIGINAL.txt"
fi

#####################################################################
# Copy required to /

# Copy autostart
if ! exists "$DEST/opt/retropie/configs/all/autostart_ORIGINAL.sh" ; then
  execute "mv $DEST/opt/retropie/configs/all/autostart.sh $DEST/opt/retropie/configs/all/autostart_ORIGINAL.sh"
fi
execute "cp $BINDIR/settings/autostart.sh $DEST/opt/retropie/configs/all/autostart.sh"
execute "chown $USER:$USER $DEST/opt/retropie/configs/all/autostart.sh"

# Copy ES safe shutdown script
execute "cp $BINDIR/settings/cs_shutdown.sh $DEST/opt/cs_shutdown.sh"

# Fix splashsreen sound
#if exists "$DEST/etc/init.d/asplashscreen" ; then
#  execute "sed -i \"s/ *both/ alsa/\" $DEST/etc/init.d/asplashscreen"
#fi
#if exists "$DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh" ; then
#  execute "sed -i \"s/ *both/ alsa/\" $DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh"
#fi

# Fix mupen64plus audio
#if exists "$DEST/opt/retropie/emulators/mupen64plus/bin/mupen64plus.sh" ; then
#  execute "sed -i \"s/mupen64plus-audio-omx/mupen64plus-audio-sdl/\" $DEST/opt/retropie/emulators/mupen64plus/bin/mupen64plus.sh"
#fi

# Fix C64 audio
#if ! exists "$PIHOMEDIR/.vice/sdl-vicerc" ; then
#  execute "mkdir -p $PIHOMEDIR/.vice/"
#  execute "echo 'SoundOutput=2' > $PIHOMEDIR/.vice/sdl-vicerc"
#  execute "chown -R $USER:$USER $PIHOMEDIR/.vice/"
#fi

# Install the pixel theme and set it as default
if ! exists "$DEST/etc/emulationstation/themes/pixel/system/theme.xml" ; then
  execute "mkdir -p $DEST/etc/emulationstation/themes"
  execute "rm -rf $DEST/etc/emulationstation/themes/pixel"
  execute "git clone --recursive --depth 1 --branch master https://github.com/kiteretro/es-theme-pixel.git $DEST/etc/emulationstation/themes/pixel"
fi

# Install the tft theme
if ! exists "$DEST/etc/emulationstation/themes/tft/system/theme.xml" ; then
  execute "mkdir -p $DEST/etc/emulationstation/themes"
  execute "rm -rf $DEST/etc/emulationstation/themes/tft"
  execute "git clone --recursive --depth 1 --branch master https://github.com/anthonycaccese/es-theme-tft.git $DEST/etc/emulationstation/themes/tft"
fi

# Set default (to tft)
#execute "sed -i \"s/carbon/tft/\" $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"

# Install runcommand splash
#if ! exists "$DEST/opt/retropie/configs/desktop/launching.png" ; then
#  execute "rm -rf /tmp/es-runcommand-splash"
#  execute "git clone --recursive --depth 1 --branch master https://github.com/ehettervik/es-runcommand-splash.git /tmp/es-runcommand-splash"
#  execute "chown -R $USER:$USER /tmp/es-runcommand-splash"
#  execute "cp -rp /tmp/es-runcommand-splash/* $DEST/opt/retropie/configs"
#  execute "rm -rf /tmp/es-runcommand-splash"
#fi

# Enable 30sec autosave
execute "sed -i \"s/# autosave_interval =/autosave_interval = \"30\"/\" $DEST/opt/retropie/configs/all/retroarch.cfg"

# Disable 'wait for network' on boot
execute "rm -f $DEST/etc/systemd/system/dhcpcd.service.d/wait.conf"

# Install rfkill
execute "dpkg -x $BINDIR/settings/rfkill_0.5-1_armhf.deb $DEST/"

# Install wiringPi
execute "dpkg -x $BINDIR/settings/wiringpi_2.46_armhf.deb $DEST/"

# Enable /ramdisk as a tmpfs (ramdisk)
if [[ $(grep '/ramdisk' $DEST/etc/fstab) == "" ]] ; then
  execute "echo 'tmpfs    /ramdisk    tmpfs    defaults,noatime,nosuid,size=100k    0 0' >> $DEST/etc/fstab"
fi

# Prepare for service install
execute "rm -f $DEST/etc/systemd/system/cs-hud.service"
execute "rm -f $DEST/etc/systemd/system/multi-user.target.wants/cs-hud.service"
execute "rm -f $DEST/lib/systemd/system/cs-hud.service"

execute "rm -f $DEST/etc/systemd/system/cs-fbcp.service"
execute "rm -f $DEST/etc/systemd/system/multi-user.target.wants/cs-fbcp.service"
execute "rm -f $DEST/lib/systemd/system/cs-fbcp.service"

# Install HUD service
execute "cp $BINDIR/cs-hud/cs-hud.service $DEST/lib/systemd/system/cs-hud.service"

execute "ln -s $DEST/lib/systemd/system/cs-hud.service $DEST/etc/systemd/system/cs-hud.service"
execute "ln -s $DEST/lib/systemd/system/cs-hud.service $DEST/etc/systemd/system/multi-user.target.wants/cs-hud.service"

# Install FBCP service
execute "cp $BINDIR/cs-fbcp/cs-fbcp.service $DEST/lib/systemd/system/cs-fbcp.service"

execute "ln -s $DEST/lib/systemd/system/cs-fbcp.service $DEST/etc/systemd/system/cs-fbcp.service"
execute "ln -s $DEST/lib/systemd/system/cs-fbcp.service $DEST/etc/systemd/system/multi-user.target.wants/cs-fbcp.service"

if [[ $DEST == "" ]] ; then
  execute "systemctl daemon-reload"
  execute "systemctl restart cs-hud.service"
  execute "systemctl restart cs-fbcp.service"
fi

#####################################################################
# DONE
echo "DONE!"
