### Get ready

* git clone git://github.com/swma/swma-wall.git
* bundle install
* install [RabbitMQ](http://www.rabbitmq.com/) 
* set Twitter username/password in app.rb 

### Launch the wall

* __ruby app.rb__ for sinatra app
* __rabbitmq-server__ for RabbitMQ server 
* go to [0.0.0.0:8001](http://0.0.0.0:8001)

### Todo

* Add style 
* Config.yml for Twitter username/password and #hashtags or string
* JS for displaying tweet