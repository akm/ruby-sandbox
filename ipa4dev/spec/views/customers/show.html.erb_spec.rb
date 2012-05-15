require 'spec_helper'

describe "customers/show.html.erb" do
  before(:each) do
    @customer = assign(:customer, stub_model(Customer,
      :customer_code => "Customer Code",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Customer Code".to_s)
    rendered.should contain("Name".to_s)
  end
end
