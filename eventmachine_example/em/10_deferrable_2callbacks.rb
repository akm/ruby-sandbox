# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

class MyDeferrable
  include EM::Deferrable
end

EM.run do
  df = MyDeferrable.new
  df.callback do |x|
    puts "1st callback"
  end
  df.callback do |x|
    puts "2nd callback"
    EM.stop
  end
  EM.add_timer(1) do
    df.set_deferred_status :succeeded, "SpeedRacer"
  end
end

# そのクラスのインスタンスには callback と errback 関連の能力が提供される。
# あなたは実行される callback と errback をいくらでも定義できる。
# callback と errback は、インスタンスに追加された順番で実行される。

# callback と errback を発動させるためには、インスタンスオブジェクトの
# #set_deferred_status を呼び出す。そのメソッドには :succeeded か
# :failed を渡すことができて、:succeeded なら callback が、:failed なら
#  errback が発動する。
