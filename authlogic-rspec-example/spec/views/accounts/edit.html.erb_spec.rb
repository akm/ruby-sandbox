require 'spec_helper'

describe "/accounts/edit" do
  before(:each) do
    assigns[:user] = User.new
    render 'accounts/edit'
  end

  it "should have form to update user" do
    response.should have_tag("form[action=#{account_path(@user)}][method=post]") do
      without_tag('input[name=?]', "user[email]")
      with_tag('input[name=?]', "user[login]")
      with_tag('input[name=?]', "user[password]")
      with_tag('input[name=?]', "user[password_confirmation]")
    end
  end
end
