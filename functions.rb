require "net/http"
require 'json'
require 'phonetic_alphabet'


def say (text)

	pid = fork do
		blink
	end
	
	if Target == :rpi
		`echo #{text} | #{Fembot}`
		$redled.off
	elsif Target == :chromebook
		`echo #{text} | #{Fembot}`
		brightness 900
	end
	Process.kill("KILL", pid)
	Process.detach(pid)
	puts "end of say"
end

def say_phonetic word
	word.to_p.split(/ /).each do |character|
		puts "will say #{character}"
		if character == ""
			#say "space"
			sleep 2
		else
			say character
			sleep 1
		end
		puts "sleep now"
		
	end
end

def dumbMode
	say DumbMessage[rand*DumbMessage.size]
	puts "new counter: #{messageCounter = 6+((rand*4)+0.4).to_i}"
	messageCounter.times do
		
		
			say (rand*1000).to_i.to_s
		
		sleep 2.5
	end
end

def cryptoMode message, offset
	message.each_char do |c|
		say (c.upcase.ord.to_i)-64+offset.to_i
		sleep 2
	end
end

def phonetic message
	message.each_char do |c|
		say c.to_p
		sleep 2
	end
end


trap("INT"){
	endProgram
}

def endProgram
	puts "Shutting down."
	if Target == :rpi
		`echo 3 > /sys/class/gpio/unexport`
		`echo 4	> /sys/class/gpio/unexport`
	elsif Target == :chromebook
			brightness 900
	end
	exit
end


def blink
	while true
		if Target == :rpi
			$redled.on
		elsif Target == :chromebook
			brightness 500
		end
		sleep Blink_period/2
		if Target == :rpi
			$redled.off
		elsif Target == :chromebook
			brightness 900
		end
		sleep Blink_period/2
		
	end
end

def brightness(brightness)
	cmd = "echo \"#{brightness}\">/sys/class/backlight/intel_backlight/brightness"
	system( cmd )
end

def tryServer(request)
	begin
		x = Net::HTTP.get(URI.parse("http://192.168.1.23:34444/#{request}"))
		puts x
		JSON.parse(x)
	rescue
		"none"
	end
end
