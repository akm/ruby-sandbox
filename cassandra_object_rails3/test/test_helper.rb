# -*- coding: utf-8 -*-
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

# /Users/takeshi/.rvm/gems/ruby-1.8.7-p249@cassandra_rails3/gems/shoulda-2.10.3/lib/shoulda/autoload_macros.rb:40:in `join': can't convert #<Class:0x100662f78> into String (TypeError)
# というようなエラーがでるので、shoulda-2.10.3/lib/shoulda/autoload_macros.rbを以下のように修正してください。
# http://www.vierundsechzig.de/blog/?p=311
# module Shoulda
#   def self.autoload_macros(root, *dirs)
#     unless root == nil
#       dirs << File.join('test')               
#       complete_dirs = dirs.map{|d| File.join(root, d, 'shoulda_macros')}
#       all_files     = complete_dirs.inject([]){ |files, dir| files + Dir[File.join(dir, '*.rb')] }
#       all_files.each do |file|
#         require file
#       end
#     end
#   end
# end

# 上記のソースを直接直すのに加えて、以下のコードも必要
Shoulda.autoload_macros(Rails.root, "vendor/bundler_gems/gems/*")

require 'rails/test_help'

require File.expand_path('./test/cassandra_object_test_case')

MockRecord = Struct.new(:key)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
