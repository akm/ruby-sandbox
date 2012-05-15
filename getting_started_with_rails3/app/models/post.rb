# -*- coding: utf-8 -*-
class Post < ActiveRecord::Base
  validates :name,  :presence => true  # nameは必須
  validates :title, :presence => true, # titleは必須
                    :length => { :minimum => 5 } # 最短でも5文字
  has_many :comments, :dependent => :destroy
  has_many :tags

  accepts_nested_attributes_for :tags, :allow_destroy => :true,
    :reject_if => proc {|attrs| attrs.all? {|k, v| v.blank? } }
end
