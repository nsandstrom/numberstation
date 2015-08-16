def readConfig
    arr = []
    File.open("current.txt", 'r').each_line do |file|
        arr << file.chomp
    end
    return {"type" => arr[0], "message" => arr[1], "option" => arr[2]}

end

def writeConfig newConfig
	matches = newConfig.match(/mode=(.*)&content=(.*)&time=(.*) /)
	if matches[1]=="crypto" && !matches[3].to_i.integer?
		return "fail must be number"
	else
		File.open("current.txt", 'w') do |file|
			matches[1..3].each do |line|
				file.puts line.gsub("+", " ")
			end
			
		end
		return "success"
	end
end

def replyToStation socket
	

    response = readConfig.to_json
     
    socket.print    "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-length: #{response.to_json.size}\r\n" +
                    "Connection: close\r\n"
                     
    socket.print    "\r\n"
     
    socket.print    response  
    socket.close  
    puts "responded with #{response}"
end

def replyToWeb socket, request
	begin
	    if request.include? "reconfig.asp"
	    	response = writeConfig request
		else
	    	puts "nay"
	    	response = buildForm
		end
		socket.print    "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/html\r\n" +
                    "Content-length: #{response.bytesize}\r\n" +
                    "Connection: close\r\n"
                     
	    socket.print    "\r\n"
	     
	    socket.print    response
	    socket.close  
	rescue
		puts "some kind of bad request"
	end
end



def buildForm

	currentMessage = readConfig

	return '<!DOCTYPE html>
<html>
<body>' + 
"Current mode is #{currentMessage["type"]} with: #{currentMessage["message"]}<br>" +
'<form action="reconfig.asp" method="get" target="_self">
Mode: <select name="mode">
<option value="dumbMode">Dumb mode</option>
<option value="crypto">Crypto</option>
<option value="phonetic">NATO phonetic alphabet</option>
<option value="wRandom">Weighted random</option>
<option value="text">Plain text</option>
</select><br>
  Content: <input type="text" name="content"><br>
  Option: <input type="text" name="time"><br>
  <input type="submit" value="Submit">
</form>

<p>' +
ModeDescriptions +
'</p>

</body>
</html>'
end