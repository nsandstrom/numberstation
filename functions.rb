require "net/http"


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

end

def dumbMode
	messageCounter = 0
	while true
		if messageCounter <= 0 then
			say DumbMessage[rand*DumbMessage.size]
			puts "new counter: #{messageCounter = 6+((rand*4)+0.4).to_i}"
		else
			say (rand*1000).to_i.to_s
		end
		messageCounter -= 1
		puts "count before sleep: #{messageCounter}"
		sleep 2.5
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
		x
	rescue
		"none"
	end
end
