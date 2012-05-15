require 'spec_helper'

describe "customers/new.html.erb" do
  before(:each) do
    assign(:customer, stub_model(Customer,
      :new_record? => true,
      :customer_code => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new customer form" do
    render

    rendered.should have_selector("form", :action => customers_path, :method => "post") do |form|
      form.should have_selector("input#customer_customer_code", :name => "customer[customer_code]")
      form.should have_selector("input#customer_name", :name => "customer[name]")
    end
  end
end
