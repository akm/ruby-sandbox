require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../authlogic_spec_helper')

describe SessionsController do
  setup_authlogic_helper(:user_session_controller => 'sessions')

  it "should use SessionsController" do
    controller.should be_an_instance_of(SessionsController)
  end

  describe "GET new" do
    it "should response login page" do
      get :new
      response.should be_success
      response.should render_template('new')
    end
  end

  describe "POST create" do
    before{ logout }
    
    it "should create user session with valid params" do
      mock_user_session = mock_model(UserSession)
      mock_user_session.should_receive(:save).and_return(true)
      UserSession.should_receive(:new).
        with('login' => "bjohnson", 'password' => "benrocks").once.
        and_return(mock_user_session)
      post :create, :user_session => { :login => "bjohnson", :password => "benrocks" }
      response.should redirect_to('/') # (account_url)
    end

    it "should create user session with invalid params" do
      mock_user_session = mock_model(UserSession)
      mock_user_session.should_receive(:save).and_return(false)
      UserSession.should_receive(:new).
        with('login' => "bjohnson", 'password' => "benrocks").once.
        and_return(mock_user_session)
      post :create, :user_session => { :login => "bjohnson", :password => "benrocks" }
      response.should be_success
      response.should render_template('new')
    end
  end

  describe "DELETE destroy" do
    before{ login_as(mock_model(User)) }

    it "should destroy user session" do
      @user_session.should_receive(:destroy)
      delete :destroy
      response.should redirect_to(new_session_path)
    end
  end

  describe "with fixtures" do
    fixtures :users
    
    login_as(:ben) do
      it "current_user is ben" do
        get 'new'
        controller.__send__(:logged_in?).should == true
        controller.__send__(:current_user).login.should == 'bjohnson'
      end
    end

    logout do
      it "current_user is nil" do
        get 'new'
        controller.__send__(:logged_in?).should == false
        controller.__send__(:current_user).should == nil
      end
    end
  end


end
