require File.join(File.dirname(__FILE__), '../spec_helper')

describe UserSessionsController do
  
  fixtures :users

  describe "GET 'new'" do
    it "should get new" do
      get :new
      response.should render_template('new')
    end
  end

  describe "POST 'create'" do
    it "should create user session" do
      post :create, :user_session => { :login => "bjohnson", :password => "benrocks" }
      user_session = UserSession.find
      user_session.should_not be_nil
      user_session.user.should == users(:ben)
      response.should redirect_to('/')
    end

    it "should not create user session for invalid password" do
      post :create, :user_session => { :login => "bjohnson", :password => "benrock" }
      user_session = UserSession.find
      user_session.should be_nil
      response.should be_success
      response.should render_template('new')
    end
  end

  describe "DELETE destroy" do
    it "should destroy user session" do
      UserSession.create(users(:ben))
      delete :destroy
      assert_nil UserSession.find
      assert_redirected_to new_user_session_path
    end
  end
end
