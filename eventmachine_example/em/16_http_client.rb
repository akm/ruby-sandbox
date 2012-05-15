# -*- coding: utf-8 -*-
#
# Original PDF download: http://everburning.com/news/eventmachine-introductions/
# Japanese translation:  http://keijinsonyaban.blogspot.com/2010/12/eventmachine.html
#
require 'eventmachine'

class Connector < EM::Connection
  def post_init
    puts "Getting /"
    req = <<EOS
GET / HTTP/1.1
Accept-Charset:Shift_JIS,utf-8;q=0.7,*;q=0.3
Accept-Language:ja,en-US;q=0.8,en;q=0.6
Host:www.postrank.com

EOS
    send_data(req)
  end

  def receive_data(data)
    puts "Received #{data.length} bytes"
    # puts data
  end
end

EM.run do
  EM.connect("www.yahoo.co.jp", 80, Connector)
end
