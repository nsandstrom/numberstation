Blink_period = 0.4

Fembot = "espeak -ven+m2 -k5 -s120 -g0 -a200 -p10  --stdout | play -t wav - \\
overdrive 2 \\
flanger 10 2 0 71 1 sin 25 lin \\
echo 0.8 0.7 12 0.7 \\
echo 0.8 0.8 5 0.7 \\
echo 0.8 0.7 6 0.7 \\
gain 8 "