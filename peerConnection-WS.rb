require File.expand_path('../../lib/em-websocket', __FILE__)
#require em-websocket

@clients = {}
@student = {}
@dozent = {}
EventMachine::WebSocket.start(:host => "10.68.0.88", :port => 10081, :debug => false) do |ws|
  ws.onopen    do
    client_id = ws.object_id
    if !@clients.include? client_id
        @clients[client_id] = ws
    end
  end
  
  ws.onmessage do |msg| 
    client_id = ws.object_id
    puts 'From Client ' + client_id.to_s + ' received message: ' + msg
    if msg.include? 'student'
        puts "client " + client_id.to_s + "is a student"
        @student[client_id] = ws
        @student[client_id].send "id: " + client_id.to_s + " Rolle: Student"
    elsif msg.include? 'dozent'
        puts "client " + client_id.to_s + "is a dozent"
        @dozent[client_id] = ws
        @dozent[client_id].send "id: " + client_id.to_s + " Rolle: Dozent"
    else
        @clients.each do |clientId, clientWs|
            if clientId != client_id
                puts 'Send to client' + clientId.to_s + 'the follow message: ' + msg
                clientWs.send "#{msg}"
            end
    end
  end

  end
  
  ws.onclose   { puts "WebSocket closed" }
  
  ws.onerror   { |e| puts "Error: #{e.message}" }
end

