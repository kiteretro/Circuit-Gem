# Extras
These collection of scripts allow additional apps to be installed quickly and easily. The general way this is done is by enabling WiFi and SSH on the Pi, SSH in to the Pi (using PuTTY or alternatives), running the command `cd Circuit-Gem/extras`, and then executing the desired script with `./<name>.sh`.

Further details on the specifics of each app are listed below.

## install_pico-8.sh
This script will install PICO-8 and make it launchable from within ES. Please follow the steps in order to successfully install it:

1. Buy PICO-8 and download the installation files for the Raspberry Pi (*_raspi.zip)
2. Insert SD card into PC and copy the installation zip in to the fat32 partition (this is `/boot/*` on the Pi filesystem.
3. Insert SD card to device and power on
4. Either via SSH, or by pluggin in a keyboard and pressing `F4` (to exit ES) run the following:
5. `cd Circuit-Gem/extras`
6. `./install_pico-8.sh`
7. The installation should run and end with "[i] INSTALLATION SUCCESSFUL! PLEASE REBOOT OR RESTART ES TO TAKE EFFECT"
8. `sudo reboot` to restart
