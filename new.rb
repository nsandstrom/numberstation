require_relative 'constants.rb'
require_relative 'functions.rb'
#load 'fembot.txt'



Target = :chromebook

if Target != :chromebook
	puts "will require Pi Piper"
	require 'pi_piper'
else
	puts "will NOT require Pi Piper"

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
rescue
	dumbMode
end
