#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

EM.run do
  EM.start_server("0.0.0.0", 10000) do |srv|
    def srv.receive_data(data)
      send_data(data)
    end
  end
end
