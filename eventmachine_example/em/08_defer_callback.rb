# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

EM.run do
  op = proc do
    2+2
  end
  callback = proc do |count|
    puts "2 + 2 == #{count}"
    EM.stop
  end
  EM.defer(op, callback)
end

# コードが走り終わったあとにコールバック関数を実行するという EM#defer の機能を利用できる。
# コールバック関数に仮引数を指定していたならば、コードの返り値がそこに渡されてから実行される。
