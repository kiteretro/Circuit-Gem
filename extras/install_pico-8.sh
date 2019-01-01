#!/bin/bash

SRCPATH="/home/pi/Circuit-Gem/extras"
RESOURCESPATH="$SRCPATH/resources/pico-8"
SEARCHPATH="/boot"
INSTALLROOTPATH="/home/pi"
INSTALLPATH="$INSTALLROOTPATH/pico-8"
LAUNCHERFILE="$RESOURCESPATH/Cartridge-Explorer.sh"

# Check existence of installation files
echo "[*] Checking for installation files in '$SEARCHPATH' with pattern 'pico*raspi.zip'.."
INSTALLFILE=$(find $SEARCHPATH -name "pico*raspi.zip" | tail -n1)
if [ -f "$INSTALLFILE" ] ; then
  echo "[i] Installation file exists as '$INSTALLFILE'"
else
  echo "ERROR: Could not fine pico8 installation files in '$SEARCHPATH' (pico*raspi.zip)"
  exit 1
fi

# Check existence of installed files
if [ -d $INSTALLPATH ] ; then
  echo "[*] Installation path '$INSTALLPATH' already exists, cleaning up.."
  #  Remove if exists
  rm -rf $INSTALLPATH
  if [[ $? == 0 ]] ; then
    echo "[i] Cleaned successfully"
  else
    echo "ERROR: Failed to clean '$INSTALLPATH'"
    exit 1
  fi
else
  echo "[i] Installation path '$INSTALLPATH' is empty"
fi

# Unzip installation files in place
echo "[*] Extracting '$INSTALLFILE' in to '$INSTALLROOTPATH'.."
unzip "$INSTALLFILE" -d "$INSTALLROOTPATH"
if [[ $? == 0 ]] ; then
  echo "[i] Extracted successfully"
else
  echo "ERROR: Failed to extract '$INSTALLFILE'"
  exit 1
fi

# Check existence of installed files
if [ -d $INSTALLPATH ] ; then
  echo "[i] Installation path '$INSTALLPATH' exists after extraction"
else
  echo "ERROR: Installation path '$INSTALLPATH' doesn't exist after extraction"
  exit 1
fi

# Copy executable
echo "[*] Copying launcher from '$LAUNCHERFILE' to '$INSTALLPATH'.."
cp "$LAUNCHERFILE" "$INSTALLPATH"
if [[ $? == 0 ]] ; then
  echo "[i] Copied successfully"
else
  echo "ERROR: Failed to copy '$LAUNCHERFILE'"
  exit 1
fi

# Get current theme
CURRENTTHEME=$(grep "ThemeSet" /opt/retropie/configs/all/emulationstation/es_settings.cfg | awk -F 'value=' '{print $2}' | awk -F '"' '{print $2}')
if [[ "$CURRENTTHEME" == "" ]] ; then
  echo "WARNING: Could not detect current 'ThemeSet' from '/opt/retropie/configs/all/emulationstation/es_settings.cfg'. Not fatal, but not good either.."
else
  echo "[i] Current ES theme found as '$CURRENTTHEME'"
  
  if [[ "$CURRENTTHEME" == "tft" ]] ; then
    if [ -d "/etc/emulationstation/themes/tft/pico8/" ] ; then
      echo "[i] 'pico8' already applied to theme in '/etc/emulationstation/themes/tft'"
    else
      echo "[*] Copying 'pico8' theme in to '/etc/emulationstation/themes/tft'"
      # TODO HERE
    fi
  fi
fi

# Check if pico8 enabled on theme
#  Copy if missing

# Check if es_systems is set
ESSET=$(grep "<name>pico8" /etc/emulationstation/es_systems.cfg)
if [[ "$ESSET" == "" ]] ; then
  # Add if not set
  echo "[*] 'pico8' not set in '/etc/emulationstation/es_systems.cfg', applying.."
  sudo sed -i 's|</systemList>|  <system>\n    <name>pico8</name>\n    <fullname>PICO-8</fullname>\n    <path>/home/pi/pico-8</path>\n    <extension>.sh .SH</extension>\n    <command>/opt/retropie/supplementary/runcommand/runcommand.sh 0 %ROM%</command>\n    <platform>pico8</platform>\n    <theme>pico8</theme>\n  </system>\n</systemList>|g' /etc/emulationstation/es_systems.cfg
  # Check if es_systems is set
  ESSET=$(grep "<name>pico8" /etc/emulationstation/es_systems.cfg)
  if [[ "$ESSET" == "" ]] ; then
    echo "ERROR: Failed to set pico8 system in '/etc/emulationstation/es_systems.cfg'"
    exit 1
  else
    echo "[i] Applied successfully"
  fi
else
  echo "[i] 'pico8' already set in '/etc/emulationstation/es_systems.cfg'"
fi

# Complete
echo "[i] INSTALLATION SUCCESSFUL! PLEASE REBOOT OR RESTART ES TO TAKE EFFECT"
