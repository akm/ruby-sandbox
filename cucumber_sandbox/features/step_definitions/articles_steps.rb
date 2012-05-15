Given /^the following articles:$/ do |articles|
  Articles.create!(articles.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) articles$/ do |pos|
  visit articles_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following articles:$/ do |expected_articles_table|
  expected_articles_table.diff!(tableish('table tr', 'td,th'))
end

Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Article.create!(:title => title)
  end
end

Given /^I have no articles$/ do
  Article.delete_all
end

Then /^I should have (\d+) article$/ do |count|
  Article.count.should == count.to_i
end
