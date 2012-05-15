# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

# EventMachine の spwened process は、Erlang のプロセスにインスパイアされている。
# OSのプロセスではないのにプロセスというネーミングには少し混乱させられるが。

EM.run do
  s = EM.spawn do |val|
    puts "Received #{val}"
  end

  EM.add_timer(1) do
    s.notify "hello"
  end
  EM.add_periodic_timer(1) do
    puts "Periodic"
  end
  EM.add_timer(3) do
    EM.stop
  end
end

# 未来のいつかの時点で、spawn されたオブジェクトの #notify メソッドを呼び出すことで、
# 付加したブロックを実行することができる。
# deferrable と異なりコードブロックはすぐ実行されないが、
# #notify 呼び出しがあったならいずれは実行される。
