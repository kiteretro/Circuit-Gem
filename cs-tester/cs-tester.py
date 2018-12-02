#!/usr/bin/env python

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

# Setup
#############################

import RPi.GPIO as GPIO 
import subprocess
import time
import datetime
import os.path

bindir = "/home/pi/Circuit-Gem/cs-tester/"

# Hardware variables
pi_shdn = 17

# Init GPIO pins
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(pi_shdn, GPIO.IN)

class bcolors:
  HEADER = '\033[95m'
  OKBLUE = '\033[94m'
  OKGREEN = '\033[92m'
  WARNING = '\033[93m'
  FAIL = '\033[91m'
  ENDC = '\033[0m'
  BOLD = '\033[1m'
  UNDERLINE = '\033[4m'

print "INFO: Started.\n"

# Test GPIO
#############################
def testGPIO():
  shdnstate = not GPIO.input(pi_shdn)
  if (shdnstate):
    print bcolors.FAIL + "GPIO SHDN   = [ OFF]" + bcolors.ENDC
  else:
    print bcolors.OKGREEN + "GPIO SHDN   = [ ON ]" + bcolors.ENDC

# LOGIC
#############################
# Main loop
try:
  while 1:
    print "\n\n\n------------------------------"
    print datetime.datetime.now().time()
    print "------------------------------"
    
    testGPIO()
    time.sleep(3)
  
except KeyboardInterrupt:
  print "Quitting.."