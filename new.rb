require "net/http"
#load 'fembot.txt'

Fembot = "espeak -ven+m2 -k5 -s200 -g0 -a200 -p10  --stdout | play -t wav - \\
overdrive 2 \\
flanger 10 2 0 71 1 sin 25 lin \\
echo 0.8 0.7 12 0.7 \\
echo 0.8 0.8 5 0.7 \\
echo 0.8 0.7 6 0.7 \\
gain 8 "

def say (text)
	`echo #{text} | #{Fembot}`
end

def dumbMode
	while true
		say (rand*1000).to_i.to_s
		sleep 1.5
	end
end

def tryServer(request)
	x = Net::HTTP.get(URI.parse("http://192.168.1.23:34444/#{request}"))
	x
	#"none"
end


if (h=tryServer("Message")) == "none" then
	say "Starting random number sequence"
	dumbMode
	sleep 2
else
	say h.to_s
	sleep 2
	#puts say "this works"
	#sleep 1
end
