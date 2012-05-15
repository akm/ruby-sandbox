# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'
require 'thread'

EM.run do
  EM.add_timer(2) do
    puts "Main #{Thread.current}"
    EM.stop_event_loop
  end
  EM.defer do
    puts "Defer #{Thread.current}"
  end
end

# EM#defer に渡したブロックは、バックグラウンドスレッドで実行が開始され、
# ゴキゲンに走り続ける
