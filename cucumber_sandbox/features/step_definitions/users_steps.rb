Given /^the following users:$/ do |users|
  Users.create!(users.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) users$/ do |pos|
  visit users_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following users:$/ do |expected_users_table|
  expected_users_table.diff!(tableish('table tr', 'td,th'))
end

Given /^the following (.+) records$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  unless email.blank?
    visit login_url
    fill_in "Email", :with => email
    fill_in "Password", :with => password
    click_button "Log in"
  end
end

When /^I visit profile for "([^"]*)"$/ do |email|
  user = User.find_by_email!(email)
  visit user_url(user)
end
