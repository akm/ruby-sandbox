require 'spec_helper'

describe "/accounts/new" do
  before(:each) do
    assigns[:user] = User.new
    render 'accounts/new'
  end

  it "should have form for register user" do
    response.should have_tag("form[action=?][method=post]", account_path) do
      with_tag('input[name=?]', "user[email]")
      with_tag('input[name=?]', "user[login]")
      with_tag('input[name=?]', "user[password]")
      with_tag('input[name=?]', "user[password_confirmation]")
    end
  end
end
