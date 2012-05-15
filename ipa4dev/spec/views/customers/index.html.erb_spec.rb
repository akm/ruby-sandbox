require 'spec_helper'

describe "customers/index.html.erb" do
  before(:each) do
    assign(:customers, [
      stub_model(Customer,
        :customer_code => "Customer Code",
        :name => "Name"
      ),
      stub_model(Customer,
        :customer_code => "Customer Code",
        :name => "Name"
      )
    ])
  end

  it "renders a list of customers" do
    render
    rendered.should have_selector("tr>td", :content => "Customer Code".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
  end
end
