#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

class Echo < EM::Connection
  def post_init
    puts "post_init"
  end

  def connection_completed
    puts "connection_completed"
  end

  def receive_data(data)
    send_data(data)
  end

  def unbind
    puts "unbind"
  end
end

EM.run do
  EM.start_server("0.0.0.0", 10000, Echo)
end
