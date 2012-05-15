# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

EM.run do
  EM.add_timer(5) do
    puts "BOOM"
    EM.stop_event_loop
  end
  EM.add_periodic_timer(1) do
    puts "Tick ... "
  end
end

# EM#stop の代わりに EM#stop_event_loop を呼ぶこともできる

# EM#add_timer と EM#add_periodic_timer の代わりに
# EM::Timer.new と EM::PeriodicTimer.new を使うこともできます
