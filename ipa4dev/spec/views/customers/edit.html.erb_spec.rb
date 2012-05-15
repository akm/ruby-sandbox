require 'spec_helper'

describe "customers/edit.html.erb" do
  before(:each) do
    @customer = assign(:customer, stub_model(Customer,
      :new_record? => false,
      :customer_code => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit customer form" do
    render

    rendered.should have_selector("form", :action => customer_path(@customer), :method => "post") do |form|
      form.should have_selector("input#customer_customer_code", :name => "customer[customer_code]")
      form.should have_selector("input#customer_name", :name => "customer[name]")
    end
  end
end
