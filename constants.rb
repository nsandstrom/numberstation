Blink_period = 0.4
BlinkLED = 17

Fembot = "espeak -ven+m2 -k5 -s120 -g0 -a200 -p10  --stdout | play -t wav - \\
overdrive 2 \\
flanger 10 2 0 71 1 sin 25 lin \\
echo 0.8 0.7 12 0.7 \\
echo 0.8 0.8 5 0.7 \\
echo 0.8 0.7 6 0.7 \\
gain 8 "

DumbMessage = [	"I got no usefull data right now",
				"This is all rubbish",
				"I am just picking numbers randomly",
				"My data uplink is broken"]





The_Raven = "Once upon a midnight dreary, while I pondered, weak and weary,
			Over many a quaint and curious volume of forgotten lore—
			While I nodded, nearly napping, suddenly there came a tapping,
			As of some one gently rapping, rapping at my chamber door.
			Tis some visitor, I muttered, tapping at my chamber door—
			Only this and nothing more."