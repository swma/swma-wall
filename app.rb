require 'rubygems'
require 'bundler'
Bundler.require
require 'twitter/json_stream'
require 'awesome_print'

uuid = UUID.new

EventMachine.run do
  # Front application
  class SwmaWall < Sinatra::Base
    set :public_folder, File.dirname(__FILE__) + '/public'
    get '/' do
     erb :index
    end
  end
  
  # not totally finished 
  def valid_tweet tweet
    oj_t  = Oj.load(tweet)
    if oj_t['retweeted'] == false && oj_t['text'].match(/RT/).nil? 
      true
    else 
      false
    end
  end
  
  # Listend on twitter stream
  AMQP.start(:host => 'localhost') do |connection, open_ok|
    AMQP::Channel.new(connection) do |channel, open_ok|
      twitter = channel.fanout("twitter")
  
      stream = Twitter::JSONStream.connect(
        :path => '/1/statuses/filter.json?track=#fail',
        :auth => "username:password"
      )
  
      stream.each_item do |tweet|
        #if valid_tweet tweet
          #ap oj_t 
          twitter.publish(tweet)
        #end
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
            ws.send t if valid_tweet t
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