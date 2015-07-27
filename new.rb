require_relative 'constants.rb'
require_relative 'functions.rb'
#load 'fembot.txt'


if ARGV.include? "-t" then

    case ARGV[ARGV.index("-t")+1]
    when "laptop", "chromebook"
    	puts "target will be chromebook"
    	Target = :chromebook
    else
    	Target = :other
    end
else
	Target = :rpi
end

if Target == :rpi

	puts "will require Pi Piper"
	require 'pi_piper'
	#include PiPiper
	$redled = PiPiper::Pin.new(:pin => 4, :direction => :out)
	$greenled = PiPiper::Pin.new(:pin => 3, :direction => :out)

else
	puts "will NOT require Pi Piper"

end




if ARGV.include? "-c" then
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
