require 'spec_helper'

describe "/users/new.html.erb" do
  include UsersHelper

  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true,
      :login => "value for login",
      :email => "value for email",
      :crypted_password => "value for crypted_password",
      :password_salt => "value for password_salt",
      :persistence_token => "value for persistence_token",
      :single_access_token => "value for single_access_token",
      :perishable_token => "value for perishable_token",
      :login_count => 1,
      :failed_login_count => 1,
      :current_login_ip => "value for current_login_ip",
      :last_login_ip => "value for last_login_ip"
    )
  end

  it "renders new user form" do
    render

    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_login[name=?]", "user[login]")
      with_tag("input#user_email[name=?]", "user[email]")
      with_tag("input#user_crypted_password[name=?]", "user[crypted_password]")
      with_tag("input#user_password_salt[name=?]", "user[password_salt]")
      with_tag("input#user_persistence_token[name=?]", "user[persistence_token]")
      with_tag("input#user_single_access_token[name=?]", "user[single_access_token]")
      with_tag("input#user_perishable_token[name=?]", "user[perishable_token]")
      with_tag("input#user_login_count[name=?]", "user[login_count]")
      with_tag("input#user_failed_login_count[name=?]", "user[failed_login_count]")
      with_tag("input#user_current_login_ip[name=?]", "user[current_login_ip]")
      with_tag("input#user_last_login_ip[name=?]", "user[last_login_ip]")
    end
  end
end
