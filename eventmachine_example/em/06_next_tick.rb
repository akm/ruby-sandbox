# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

EM.run do
  EM.add_periodic_timer(1) do
    puts "Hai"
  end
  EM.add_timer(5) do
    EM.next_tick do
      EM.stop_event_loop
    end
  end
end

# EM#next_tick を使うことは、EM#add_timer を動かすのにとてもよく似ている
# EM#next_tick に渡した特定のコードブロックは、
# reactor ループの次のイテレーションで実行される。
