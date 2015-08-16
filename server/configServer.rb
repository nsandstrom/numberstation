require "net/http"
require 'phonetic_alphabet'
require_relative 'constants.rb'
require_relative 'serverFunctions.rb'



LOCAL_IP = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address








server = TCPServer.new(LOCAL_IP, 33333)
puts "I'm now running on #{LOCAL_IP}."

loop do
	socket = server.accept      #Socket. I/O subclass
    puts '======Got request!======'
    request = socket.gets       #Read one line from socket. First line. Contains request.
         
    puts "Request from client: #{request}"          #prints the request from client
     
    #request.gsub!('GET ', '').gsub!('HTTP/1.1', '')

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