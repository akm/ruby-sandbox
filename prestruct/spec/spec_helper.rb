$KCODE='u'

require 'rubygems'
gem 'rspec', '>= 1.1.4'
require 'spec'
require 'spec/autorun'

require 'yaml'
begin
  require 'yaml_waml'
rescue
  $stderr.puts "yaml_waml not found. You should [sudo] gem install kakutani-yaml_waml"
end

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'prestruct'
