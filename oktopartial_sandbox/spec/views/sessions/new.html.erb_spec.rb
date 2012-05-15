require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/sessions/new" do
  before(:each) do
    assigns[:user_session] = session = mock_model(UserSession, 
      :login => nil, :password => nil, :remember_me => nil)
    render
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    begin
      response.should have_tag('form[action=?]', '/session') do
        with_tag('input[name=?]', 'user_session[login]')
        with_tag('input[name=?]', 'user_session[password]')
        with_tag('input[name=?]', 'user_session[remember_me]')
      end
    rescue Exception
      puts "  " << $!.backtrace.join("\n  ")
      raise
    end
  end
end
