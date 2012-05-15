# -*- coding: utf-8 -*-
require 'ruby-processing'

class MovableDot < Processing::App

  attr_accessor :pattern, :square_x, :square_y

  def setup
    smooth
    @dot, @square_x, @square_y = [], [], []
    @pattern, @index = 0, 0
    @dot_size, @dot_margin = 10, 2

    20.times do |j|
      20.times do |i|
        tmp_x , tmp_y = %w(width height).map do |wh|
          i * (@dot_size + @dot_margin) + self.__send__(wh)/2 - 20 * ((@dot_size + @dot_margin)/2)
        end
        @dot[@index] = Dot.new(@dot_size, @dot_size, tmp_x.to_f, tmp_y.to_f, 50, @index)
        @square_x[@index] = tmp_x
        @square_y[@index] = tmp_y
        @index += 1
      end
    end
  end
  
  def draw
    background 0
    @dot.each_with_index do |x, i|
      x.display i
      x.move
    end
  end
  
  def mouse_pressed
    if @pattern < 2
      @pattern += 1
    else
      @pattern = 0
    end
  end
end

MovableDot.new :title => "Movable Dot", :width => 300, :height => 300

class Dot
  include Math
  attr_accessor :rect_width, :rect_height, :dot_num

  def initialize(w, h, x, y, the_color, dot_count)
    @app = Processing::App.current
    @rect_width, @rect_height = w, h
    @x_pos, @y_pos = x, y
    @c = the_color
    @dot_num = dot_count
    @speed = 0.05
    @next_x, @next_y = 0.0, 0.0
  end

  def display(idx)
    c1 = @app.color(rand(idx), rand(idx), rand(idx), rand(idx))
    @app.fill c1
    @app.stroke c1
    @app.rect_mode @app.class.const_get("CENTER")
    @app.rect(@x_pos, @y_pos, @rect_width, @rect_height)
  end

  def move
    # 最初に気になったのはここ
    # 数値が直接書いてあるのがコードを分かりにくくしてる気がします。
    # やっぱこういうのはSymbolで書きたいっす。
    case @app.pattern
    when 0
      @next_x, @next_y = [@app.square_x, @app.square_y].map{|elm| elm[@dot_num]}
    when 1
      @next_x, @next_y = %w(width height).map do |wh|
        val, sin_or_cos = wh == 'width' ? [10, 'sin'] : [20, 'cos']
        (@app.__send__(wh)/2-val) * self.__send__(sin_or_cos, (self.dot_num * 2 * PI/@app.__send__(wh))) + @app.__send__(wh)/2
      end
    else
      @next_x += @app.random(-@app.width/8, @app.width/8)
      @next_y += @app.random(-@app.height/8, @app.height/8)
    end

    @x_pos -= (@x_pos - @next_x) * @speed
    @y_pos -= (@y_pos - @next_y) * @speed
  end
end
