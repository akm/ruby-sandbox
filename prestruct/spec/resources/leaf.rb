# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/root'

class Leaf < Root
  class_desc :name => "葉っぱ"
  
  desc :name => "ほげ", :hidden => true
  def hoge
  end
  
  desc :auth_as => "hoge"
  def hage
  end
end
