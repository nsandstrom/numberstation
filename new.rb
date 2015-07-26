require "net/http"
require 'pi_piper'
require_relative 'constants.rb'
#load 'fembot.txt'



def say (text)
	pid = fork do
		blink
	end
	`echo #{text} | #{Fembot}`
	if Target == "chromebook"
		brightness 900
	end
	Process.kill("KILL", pid)
end

def dumbMode
	while true
		say (rand*1000).to_i.to_s
		sleep 1.5
	end
end

def blink
	while true
		sleep Blink_period/2
		if Target == "chromebook"
			brightness 500
		end
		sleep Blink_period/2
		if Target == "chromebook"
			brightness 900
		end
	end
end

def brightness(brightness)
	cmd = "echo \"#{brightness}\">/sys/class/backlight/intel_backlight/brightness"
	system( cmd )
end

def tryServer(request)
	begin
		x = Net::HTTP.get(URI.parse("http://192.168.1.23:34444/#{request}"))
		x
	rescue
		"none"
	end
end

Target = "chromebook"

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
rescue
	dumbMode
end
