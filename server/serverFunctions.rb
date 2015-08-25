def readConfig
	begin
	    arr = []
	    File.open("current.txt", 'r').each_line do |file|
	        arr << file.chomp
	    end
	    return {"type" => arr[0], "message" => arr[1], "option" => arr[2]}
	rescue
		return {"type" => "none", "message" => "no config file", "option" => "0"}
	end
end

def writeConfig newConfig
	matches = newConfig.match(/mode=(.*)&content=(.*)&time=(.*) /)

	
	File.open("current.txt", 'w') do |file|
		file.puts matches[1].gsub("+", " ")
		file.puts matches[2].gsub("+", " ").gsub(/%[0-9a-zA-Z]{2}/, "")
		file.puts matches[3].gsub("+", " ").to_i
		
	end
	return "success"
	
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
	    	response = buildReception(writeConfig(request))
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

def buildReception status
return '<!DOCTYPE html>
<html>
<body>' + 
status +
'<br><a href="/">Back</a>
</body>
</html>'
end

def buildForm

	currentMessage = readConfig

	return '<!DOCTYPE html>
<html>
<body>' + 
"Current mode is #{currentMessage["type"]} with: #{currentMessage["message"]}<br>" +
'<form action="reconfig.asp" method="get" target="_self">
Mode: <select name="mode">
<option value="crypto">Crypto</option>
<option value="phonetic">NATO phonetic alphabet</option>
<option value="text">Plain text</option>
<option value="dumbMode">Dumb mode</option>
<option value="wRandom">Weighted random</option>
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