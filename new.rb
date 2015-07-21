require "net/http"
#load 'fembot.txt'

Fembot = "espeak -ven+m2 -k5 -s120 -g0 -a200 -p10  --stdout | play -t wav - \\
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
	begin
		x = Net::HTTP.get(URI.parse("http://192.168.1.23:34444/#{request}"))
		x
	rescue
		"none"
	end
end

if ARGV.include? "-t" then
    text = ARGV[ARGV.index("-t")+1..ARGV.size].join(" ")
    puts text
elsif ARGV.include? "-m"
	text = "Message"
elsif ARGV.include? "-p"
	text = "Poem"
else
	dumbMode
end

begin
	if (h=tryServer(text)) == "none" then
		say text.to_s
		#dumbMode
	else
		say h.to_s
		#puts say "this works"
		#sleep 1
	end
#rescue
#	dumbMode
end
