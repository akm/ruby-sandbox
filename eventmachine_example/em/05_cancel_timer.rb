#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

EM.run do
  p = EM.add_periodic_timer(1) do
    puts "Tick ..."
  end

  EM.add_timer(5) do
    puts "BOOM"
    p.cancel
  end

  EM.add_timer(8) do
    puts "The googles, they do nothing"
    EM.stop
  end
end
