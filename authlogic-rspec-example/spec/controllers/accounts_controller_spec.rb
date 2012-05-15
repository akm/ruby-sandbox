require File.join(File.dirname(__FILE__), '../spec_helper')

describe AccountsController do
  fixtures :users
  
  #Delete these examples and add some real ones
  it "should use AccountsController" do
    controller.should be_an_instance_of(AccountsController)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should redirect if login" do
      UserSession.create(users(:ben))
      get 'new'
      response.should redirect_to(:controller => "account")
    end
  end

  describe "POST 'create'" do
    it "should create user" do
      lambda{
        post :create, :user => { :login => "ben", :email => "ben@example.com",
          :password => "benrocks", :password_confirmation => "benrocks" }
      }.should change(User, :count).by(1)
      response.should redirect_to(account_path)
    end

    it "should not create user for duplicated email" do
      lambda{
        post :create, :user => { :login => "ben", :email => "bjohnson@example.com",
          :password => "benrocks", :password_confirmation => "benrocks" }
      }.should_not change(User, :count)
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      UserSession.create(users(:ben))
      get 'edit'
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should update user" do
      UserSession.create(users(:ben))
      put :update, :id => users(:ben).id, :user => { }
      response.should redirect_to(account_path)
    end

    it "should not update user if same email has already existed." do
      UserSession.create(users(:akimatter))
      put :update, :id => users(:akimatter).id, :user => {:email => users(:ben).email }
      response.should render_template("edit")
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      UserSession.create(users(:ben))
      get 'show'
      response.should be_success
    end

    it "should redirect unless login" do
      get 'show'
      response.should redirect_to(:controller => 'user_session', :action => 'new')
    end
  end
end
