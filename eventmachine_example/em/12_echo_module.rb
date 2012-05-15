#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

module Echo
  def receive_data(data)
    send_data(data)
  end
end

EM.run do
  EM.start_server("0.0.0.0", 10000, Echo)
end
