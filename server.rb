require "net/http"
require 'json'



LOCAL_IP = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address

def readFile
    arr = []
    File.open("current.txt", 'r').each_line do |file|
        arr << file.chomp
    end
    return {"type" => arr[0], "message" => arr[1], "option" => arr[2]}

end


server = TCPServer.new(LOCAL_IP, 34444)
puts "I'm now running on #{LOCAL_IP}."
#puts readFile
loop do
	socket = server.accept      #Socket. I/O subclass
    puts '======Got request!======'
    request = socket.gets       #Read one line from socket. First line. Contains request.
         
    puts "Request from client: #{request}"          #prints the request from client
     
    request.gsub!('GET ', '').gsub!('HTTP/1.1', '')

    case request
    when /Message/
    	response = "Butsex"
    when /Poem/
    	response = The_Raven.gsub("\n", " ")
    else
    	response = {"message" =>"none", "type" => "Test"}  #string, containing reply to client 
    end


    response = readFile.to_json
     
     
    socket.print    "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-length: #{response.to_json.size}\r\n" +
                    "Connection: close\r\n"
                     
    socket.print    "\r\n"
     
    socket.print    response  
    socket.close  
    puts "responded with #{response}"
	
end