# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

class Pass < EM::Connection
  attr_accessor :a, :b
  def receive_data(data)
    send_data "#{@a} #{data.chomp} #{b}"
  end
end

EM.run do
  EM.start_server("127.0.0.1", 10000, Pass) do |conn|
    conn.a = "Goodbye"
    conn.b = "world"
  end
end

# EM#start_server へ渡されたブロックの中で、Pass インスタンスは自身が初期化された後、
# クライアントからデータを受け取る前に、EventMachine から値が渡されている。
# このどんな状態でもセットされたインスタンスを、必要ならば使うことができる。
