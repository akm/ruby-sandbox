# -*- coding: utf-8 -*-
# 引数countの数だけyieldによって渡されたブロックを呼び出します。
# ブロックが渡されない場合も考慮してblock_given?でブロックが渡されたかどうかをチェックします
def repeat(count)
  if block_given?
    count.times do |i|
      yield
    end
  end
end
repeat(3){ puts "a"}

# 渡されたブロックに引数を渡して呼び出すためにはyieldに引数を渡します
def repeat(count)
  if block_given?
    count.times do |i|
      yield(i)
    end
  end
end
repeat(3){|i| puts "a" * i}

# 仮引数の定義の後に&xxxと記述することで、ブロックをProcオブジェクトとして受け付けることができます
def repeat(count, &block1)
  if block_given?
    count.times do |i|
      yield(i)
    end
  end
end
repeat(3){|i| puts "a" * i}

# ブロックが渡されたかどうかはblock1がnilかどうかで判断できます。
# Proc#call で呼び出すことができます
# http://doc.ruby-lang.org/ja/1.9.2/method/Proc/i/call.html
def repeat(count, &block1)
  if block1
    count.times do |i|
      block1.call(i)
    end
  end
end
repeat(3){|i| puts "a" * i}

# count.times に渡されているブロックをよく見ると
# [block1を呼び出すだけのブロック]になっているので、count.timesに直接block1を渡します。
def repeat(count, &block1)
  if block1
    count.times(&block1)
  end
end
repeat(3){|i| puts "a" * i}
