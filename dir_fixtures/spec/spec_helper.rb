$KCODE='u'

require 'rubygems'
gem 'rspec', '>= 1.1.4'
require 'spec'
require 'spec/autorun'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

# require File.join(File.dirname(__FILE__), '..', 'init')
require File.join(File.dirname(__FILE__), '..', 'lib', 'dir_fixtures')
