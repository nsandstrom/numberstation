require "net/http"


def say (text)
	pid = fork do
		blink
	end
	`echo #{text} | #{Fembot}`
	if Target == :rpi
		$redled.off
	elsif Target == :chromebook
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
		if Target == :rpi
			$redled.on
		elsif Target == :chromebook
			brightness 500
		end
		sleep Blink_period/2
		if Target == :rpi
			$redled.on
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