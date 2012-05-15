require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/request_sendings/index.html.erb" do
  include RequestSendingsHelper
  
  before(:each) do
    assigns[:request_sendings] = [
      stub_model(RequestSending,
        :method => "value for method",
        :uri => "value for uri",
        :parameters => "value for parameters",
        :headers => "value for headers"
      ),
      stub_model(RequestSending,
        :method => "value for method",
        :uri => "value for uri",
        :parameters => "value for parameters",
        :headers => "value for headers"
      )
    ]
  end

  it "renders a list of request_sendings" do
    render
    response.should have_tag("tr>td", "value for method".to_s, 2)
    response.should have_tag("tr>td", "value for uri".to_s, 2)
    response.should have_tag("tr>td", "value for parameters".to_s, 2)
    response.should have_tag("tr>td", "value for headers".to_s, 2)
  end
end

