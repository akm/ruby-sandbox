# -*- coding: utf-8 -*-

# each に 渡している do...end がブロック
[1,2,3].each do |i|
  puts i
end

# do...end の代わりに {...} を使うことも可能。
[1,2,3].each{|i| puts i}

# ブロックを lambda, proc, Proc.new などによってProcオブジェクトとして扱うことも可能。
block1 = lambda{|i| puts i}

# ProcオブジェクトをArray#eachメソッドにブロックとして渡します
[1,2,3].each(&block1)
