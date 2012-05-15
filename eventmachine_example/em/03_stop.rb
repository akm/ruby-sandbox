# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
# このコードについてのシーケンス図
# https://cacoo.com/diagrams/Fa6695kYkMH1tT2a
#
require 'eventmachine'

EM.run do
  EM.add_timer(1) { EM.stop }
end

# こっちでは EM#run にブロックを渡している。
# [ブロックの中身]は reactor が初期化された"あと"、
#                  reactor が走り始める"前"に実行される。
# 必要な初期化処理があれば、なんでもこのブロックに入れることができる。
# この場合は、時が来たら EM#stop を実行してくれるタイマーを作成している
