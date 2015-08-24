require "net/http"
require 'json'
require_relative 'constants.rb'
require_relative 'serverFunctions.rb'


begin
    LOCAL_IP = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
rescue
    LOCAL_IP = "31.192.231.98"
end




server = TCPServer.new(LOCAL_IP, 34444)
puts "I'm now running on #{LOCAL_IP}."
#puts readFile
loop do
    begin
    	socket = server.accept      #Socket. I/O subclass
        puts '======Got request!======'
        request = socket.gets       #Read one line from socket. First line. Contains request.
             
        puts "Request from client: #{request}"          #prints the request from client
         
        if request.include? "Message"
            replyToStation socket
        else
            replyToWeb socket, request
        end
    rescue
        puts "som kind of bad request"
    end
	
end