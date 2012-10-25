### Get ready

* git clone git://github.com/swma/swma-wall.git
* bundle install
* install [RabbitMQ](http://www.rabbitmq.com/) 
* set Twitter username/password in app.rb 
* set Google Calendar username/password in app.rb ()

# Options
* the events of google calendar are search in ten minutes after the current time, if you want change this you can,
  just change in the file public/javascript/show_event_google_calendar.js the number in line 4 (is in seconds)

### Launch the wall

* __ruby app.rb__ for sinatra app
* __rabbitmq-server__ for RabbitMQ server 
* go to [0.0.0.0:8001](http://0.0.0.0:8001)

### Todo

* Add style 
* Config or env var Twitter username/password and #hashtags
* JS for displaying tweet
* Synchronization with Google Calendar for events