# Source
Forked from: https://github.com/adafruit/Adafruit_Userspace_PiTFT

# Changes
* Custom res for restricted viewport
* Default to try for 60FPS
* Init will clear any 'unset' pixels to black

# Todo
* Try out different SPI bufsiz 
`cat /sys/module/spidev/parameters/bufsiz` --> 4096 default
`/boot/cmdline.txt` --> add `spidev.bufsiz=xxxx`
