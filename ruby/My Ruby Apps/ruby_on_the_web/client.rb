require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 3000

s = TCPSocket.open(hostname, port)

while line = s.gets   # Read lines from the socket
  puts line.chop      # And print with platform line terminator
end

def get_request_type
	request_type = ""
	while request_type != ("GET" || "POST" || "HEAD")
		puts "What kind of request would you like to make?"
		request_type = gets.chomp
	end
end
s.close               # Close the socket when done