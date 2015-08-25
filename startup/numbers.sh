#!/bin/sh

#/usr/bin/ruby /agab/rbDelay.rb
amixer set PCM -- -000 #max volume
amixer cset numid=3 1 # force headphone (PWM) output
echo delaying
sleep 5
/usr/bin/ruby /home/pi/dev/bbr/numberstation/new.rb
