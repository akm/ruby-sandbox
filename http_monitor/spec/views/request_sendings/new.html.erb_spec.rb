require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/request_sendings/new.html.erb" do
  include RequestSendingsHelper
  
  before(:each) do
    assigns[:request_sending] = stub_model(RequestSending,
      :new_record? => true,
      :method => "value for method",
      :uri => "value for uri",
      :parameters => "value for parameters",
      :headers => "value for headers"
    )
  end

  it "renders new request_sending form" do
    render
    
    response.should have_tag("form[action=?][method=post]", request_sendings_path) do
      with_tag("input#request_sending_method[name=?]", "request_sending[method]")
      with_tag("input#request_sending_uri[name=?]", "request_sending[uri]")
      with_tag("textarea#request_sending_parameters[name=?]", "request_sending[parameters]")
      with_tag("textarea#request_sending_headers[name=?]", "request_sending[headers]")
    end
  end
end


