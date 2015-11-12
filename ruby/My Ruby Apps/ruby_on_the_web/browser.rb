require 'socket'
require 'json'
 
host = 'localhost'      # The web server
port = 3000             # Default HTTP port  
request_type = ""		# This is the HTTP request we send to fetch a file
path = ""  				# The file we want 
version = "HTTP/1.0\r\n\r\n"             # This is where #{version} is assigned, set as a default

params = Hash.new { |hash, key| hash[key] = Hash.new }		#params for a POST request

until request_type == "GET" || request_type == "POST" || request_type == "HEAD"		#This is where #{request_type} is assigned
	puts "What kind of request would you like to make?"
	request_type = gets.chomp.upcase
end

case request_type		# End of each case is where #{path} is assigned
when "GET"
	puts "Here is your requested web page:"
	path = "index.html"
when "POST"
	puts "What is your name?"
	v_name = gets.chomp
	params[:viking][:name] = v_name
	puts "What is your email?"
	v_email = gets.chomp
	params[:viking][:email] = v_email
	path = "thanks.html #{params.to_json}"
end

request = "#{request_type} #{path} #{version}"
socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read
headers,body = response.split("\r\n\r\n", 2)  # Split response at first blank line into headers and body
puts ''
print body
socket.close