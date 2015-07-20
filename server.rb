require "net/http"


LOCAL_IP = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
server = TCPServer.new(LOCAL_IP, 34444)
puts "I'm now running on #{LOCAL_IP}."

loop do
	socket = server.accept      #Socket. I/O subclass
    puts '======Got request!======'
    request = socket.gets       #Read one line from socket. First line. Contains request.
         
    puts "Request from client: #{request}"          #prints the request from client
     
    request.gsub!('GET ', '').gsub!('HTTP/1.1', '')

    case request
    when /Message/
    	response = "This is the message of the day"
    else
    	response = "Time to sleep"   #string, containing reply to client 
    end
     
     
    socket.print    "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-length: #{response.bytesize}\r\n" +
                    "Connection: close\r\n"
                     
    socket.print    "\r\n"
     
    socket.print    response  
    socket.close  
	
end