# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

class Echo < EM::Connection
  def receive_data(data)
    send_data(data)
  end
end

EM.run do
  EM.start_server("0.0.0.0", 10000, Echo)
end

# $ telnet localhost 10000
# Trying 127.0.0.1...
# Connected to localhost.
# Escape character is '^]'.
# helo
# helo
# goodbye cruel world
# goodbye cruel world
# ^]
# telnet> quit
# Connection closed.
# ~$ 

# 本質的には、Echo クラスのインスタンスはファイルディスクリプタに結びつけられているッ！
# ファイルディスクリプタに動きがあればいつでも、君のクラスのインスタンスは
#   そのアクションをハンドルするために呼ばれるのだッ！
# これがほとんどの EventMachine プログラミングの基礎であり、
#   reactor はファイルディスクリプタを監視し、
#   君のクラスのインスタンスにあるコールバックを実行するッ！
