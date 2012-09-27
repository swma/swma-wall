require 'bundler'
Bundler.setup
require 'sinatra/base'
require 'em-websocket'
require 'uuid'
require 'amqp'
require 'twitter/json_stream'
require 'thin'

uuid = UUID.new

EventMachine.run do
  # Front application
  class SwmaWall < Sinatra::Base
    set :public_folder, File.dirname(__FILE__) + '/public'
    get '/' do
     erb :index
    end
  end
  
  # Listend on twitter stream
  AMQP.start(:host => 'localhost') do |connection, open_ok|
    AMQP::Channel.new(connection) do |channel, open_ok|
      twitter = channel.fanout("twitter")
  
      stream = Twitter::JSONStream.connect(
        :path => '/1/statuses/filter.json?track=#sexy',
        :auth => "username:password"
      )
  
      stream.each_item do |status|
        twitter.publish(status)
      end
    end
  end
  
  # Create webservice
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do
      puts "WebSocket opened"
      AMQP.connect(:host => '127.0.0.1') do |connection, open_ok|
        AMQP::Channel.new(connection) do |channel, open_ok|
          channel.queue(uuid.generate, :auto_delete => true).bind(channel.fanout("twitter")).subscribe do |t|
            puts 'got a tweet'
            ws.send t
          end
        end
      end
    end
  
    ws.onclose do
      puts "WebSocket closed"
    end
  end
  
  Thin::Server.start SwmaWall, '0.0.0.0', 8001
end