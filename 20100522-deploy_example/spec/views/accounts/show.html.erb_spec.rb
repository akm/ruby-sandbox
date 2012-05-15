require 'spec_helper'

describe "/accounts/show" do
  fixtures :users
  
  before(:each) do
    assigns[:user] = users(:ben)
    render 'accounts/show'
  end

  it "should show account informations" do
    response.should have_text(/bjohnson/)
  end
end
