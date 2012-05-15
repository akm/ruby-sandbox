require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RequestSendingsController do

  def mock_request_sending(stubs={})
    @mock_request_sending ||= mock_model(RequestSending, stubs)
  end
  
  describe "GET index" do
    it "assigns all request_sendings as @request_sendings" do
      RequestSending.should_receive(:find).with(:all).and_return([mock_request_sending])
      get :index
      assigns[:request_sendings].should == [mock_request_sending]
    end
  end

  describe "GET show" do
    it "assigns the requested request_sending as @request_sending" do
      RequestSending.should_receive(:find).with("37").and_return(mock_request_sending)
      get :show, :id => "37"
      assigns[:request_sending].should equal(mock_request_sending)
    end
  end

  describe "GET new" do
    it "assigns a new request_sending as @request_sending" do
      RequestSending.should_receive(:new).and_return(mock_request_sending)
      get :new
      assigns[:request_sending].should equal(mock_request_sending)
    end
  end

  describe "GET edit" do
    it "assigns the requested request_sending as @request_sending" do
      RequestSending.should_receive(:find).with("37").and_return(mock_request_sending)
      get :edit, :id => "37"
      assigns[:request_sending].should equal(mock_request_sending)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created request_sending as @request_sending" do
        RequestSending.should_receive(:new).with({'these' => 'params'}).and_return(mock_request_sending(:save => true))
        post :create, :request_sending => {:these => 'params'}
        assigns[:request_sending].should equal(mock_request_sending)
      end

      it "redirects to the created request_sending" do
        RequestSending.stub!(:new).and_return(mock_request_sending(:save => true))
        post :create, :request_sending => {}
        response.should redirect_to(request_sending_url(mock_request_sending))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved request_sending as @request_sending" do
        RequestSending.stub!(:new).with({'these' => 'params'}).and_return(mock_request_sending(:save => false))
        post :create, :request_sending => {:these => 'params'}
        assigns[:request_sending].should equal(mock_request_sending)
      end

      it "re-renders the 'new' template" do
        RequestSending.stub!(:new).and_return(mock_request_sending(:save => false))
        post :create, :request_sending => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested request_sending" do
        RequestSending.should_receive(:find).with("37").and_return(mock_request_sending)
        mock_request_sending.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :request_sending => {:these => 'params'}
      end

      it "assigns the requested request_sending as @request_sending" do
        RequestSending.stub!(:find).and_return(mock_request_sending(:update_attributes => true))
        put :update, :id => "1"
        assigns[:request_sending].should equal(mock_request_sending)
      end

      it "redirects to the request_sending" do
        RequestSending.stub!(:find).and_return(mock_request_sending(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(request_sending_url(mock_request_sending))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested request_sending" do
        RequestSending.should_receive(:find).with("37").and_return(mock_request_sending)
        mock_request_sending.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :request_sending => {:these => 'params'}
      end

      it "assigns the request_sending as @request_sending" do
        RequestSending.stub!(:find).and_return(mock_request_sending(:update_attributes => false))
        put :update, :id => "1"
        assigns[:request_sending].should equal(mock_request_sending)
      end

      it "re-renders the 'edit' template" do
        RequestSending.stub!(:find).and_return(mock_request_sending(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested request_sending" do
      RequestSending.should_receive(:find).with("37").and_return(mock_request_sending)
      mock_request_sending.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the request_sendings list" do
      RequestSending.stub!(:find).and_return(mock_request_sending(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(request_sendings_url)
    end
  end

end
