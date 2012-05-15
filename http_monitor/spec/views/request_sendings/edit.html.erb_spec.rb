require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/request_sendings/edit.html.erb" do
  include RequestSendingsHelper
  
  before(:each) do
    assigns[:request_sending] = @request_sending = stub_model(RequestSending,
      :new_record? => false,
      :method => "value for method",
      :uri => "value for uri",
      :parameters => "value for parameters",
      :headers => "value for headers"
    )
  end

  it "renders the edit request_sending form" do
    render
    
    response.should have_tag("form[action=#{request_sending_path(@request_sending)}][method=post]") do
      with_tag('input#request_sending_method[name=?]', "request_sending[method]")
      with_tag('input#request_sending_uri[name=?]', "request_sending[uri]")
      with_tag('textarea#request_sending_parameters[name=?]', "request_sending[parameters]")
      with_tag('textarea#request_sending_headers[name=?]', "request_sending[headers]")
    end
  end
end


