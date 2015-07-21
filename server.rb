require "net/http"


LOCAL_IP = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address

The_Raven = "Once upon a midnight dreary, while I pondered, weak and weary,
Over many a quaint and curious volume of forgotten lore—
    While I nodded, nearly napping, suddenly there came a tapping,
As of some one gently rapping, rapping at my chamber door.
Tis some visitor, I muttered, tapping at my chamber door—
            Only this and nothing more."


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
    	response = "Butsex"
    when /Poem/
    	response = The_Raven.gsub("\n", " ")
    else
    	response = "none"   #string, containing reply to client 
    end
     
     
    socket.print    "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-length: #{response.bytesize}\r\n" +
                    "Connection: close\r\n"
                     
    socket.print    "\r\n"
     
    socket.print    response  
    socket.close  
	
end