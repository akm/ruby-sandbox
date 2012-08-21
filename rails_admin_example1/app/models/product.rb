class Product < ActiveRecord::Base
  attr_accessible :code, :name, :price
end
