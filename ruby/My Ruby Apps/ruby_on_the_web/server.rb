require 'socket'
require 'json'

server = TCPServer.open(3000)  # Socket to listen on port 2000
loop {                         # Servers run forever
	  	client = server.accept       # Wait for a client to connect
	  	request = client.gets		# get browser request from client
		split = request.split(" ")
		method = split[0]
		path = split[1..-1]
		version = request.match(/(HTTP\/...)/)

		if File.exists?(path[0])
			f = File.read(path[0])
			puts "HTTP/1.0 200 OK" + "\n" + "Created at: #{Time.now}" + "\n" +
						"Content-Length: #{f.size}"
			if method == "GET"
				puts f
			elsif method == 'POST'
       			params = JSON.parse(path[1])
       			user_data = "<li>name: #{params['viking']['name']}</li><li>e-mail: #{params['viking']['email']}</li>"
       			puts f.gsub('<%= yield %>', user_data)
     		end
		else
			puts "HTTP/1.0 404 File Not Found"
		end

  		client.puts "Closing the connection. Bye!"
  		client.close                 # Disconnect from the client
}