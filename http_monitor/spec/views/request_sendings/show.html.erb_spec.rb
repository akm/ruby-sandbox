require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/request_sendings/show.html.erb" do
  include RequestSendingsHelper
  before(:each) do
    assigns[:request_sending] = @request_sending = stub_model(RequestSending,
      :method => "value for method",
      :uri => "value for uri",
      :parameters => "value for parameters",
      :headers => "value for headers"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ method/)
    response.should have_text(/value\ for\ uri/)
    response.should have_text(/value\ for\ parameters/)
    response.should have_text(/value\ for\ headers/)
  end
end

