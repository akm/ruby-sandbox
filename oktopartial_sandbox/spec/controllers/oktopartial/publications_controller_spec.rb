require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Oktopartial::PublicationsController do

  def mock_publication(stubs={})
    @mock_publication ||= mock_model(Oktopartial::Publication, stubs)
  end

  describe "GET index" do
    it "assigns all oktopartial_publications as @publications" do
      Oktopartial::Publication.stub!(:find).with(:all).and_return([mock_publication])
      get :index
      assigns[:publications].should == [mock_publication]
    end
  end

  describe "GET show" do
    it "assigns the requested publication as @publication" do
      Oktopartial::Publication.stub!(:find).with("37").and_return(mock_publication)
      get :show, :id => "37"
      assigns[:publication].should equal(mock_publication)
    end
  end

  describe "GET new" do
    it "assigns a new publication as @publication" do
      Oktopartial::Publication.stub!(:new).and_return(mock_publication)
      get :new
      assigns[:publication].should equal(mock_publication)
    end
  end

  describe "GET edit" do
    it "assigns the requested publication as @publication" do
      Oktopartial::Publication.stub!(:find).with("37").and_return(mock_publication)
      get :edit, :id => "37"
      assigns[:publication].should equal(mock_publication)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created publication as @publication" do
        Oktopartial::Publication.stub!(:new).with({'these' => 'params'}).and_return(mock_publication(:save => true))
        post :create, :publication => {:these => 'params'}
        assigns[:publication].should equal(mock_publication)
      end

      it "redirects to the created publication" do
        Oktopartial::Publication.stub!(:new).and_return(mock_publication(:save => true))
        post :create, :publication => {}
        response.should redirect_to(:controller => 'oktopartial/publications', :action => :show, :id => mock_publication.id)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved publication as @publication" do
        Oktopartial::Publication.stub!(:new).with({'these' => 'params'}).and_return(mock_publication(:save => false))
        post :create, :publication => {:these => 'params'}
        assigns[:publication].should equal(mock_publication)
      end

      it "re-renders the 'new' template" do
        Oktopartial::Publication.stub!(:new).and_return(mock_publication(:save => false))
        post :create, :publication => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested publication" do
        Oktopartial::Publication.should_receive(:find).with("37").and_return(mock_publication)
        mock_publication.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :publication => {:these => 'params'}
      end

      it "assigns the requested publication as @publication" do
        Oktopartial::Publication.stub!(:find).and_return(mock_publication(:update_attributes => true))
        put :update, :id => "1"
        assigns[:publication].should equal(mock_publication)
      end

      it "redirects to the publication" do
        Oktopartial::Publication.stub!(:find).and_return(mock_publication(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(:controller => 'oktopartial/publications', :action => :show, :id => mock_publication.id)
      end
    end

    describe "with invalid params" do
      it "updates the requested publication" do
        Oktopartial::Publication.should_receive(:find).with("37").and_return(mock_publication)
        mock_publication.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :publication => {:these => 'params'}
      end

      it "assigns the publication as @publication" do
        Oktopartial::Publication.stub!(:find).and_return(mock_publication(:update_attributes => false))
        put :update, :id => "1"
        assigns[:publication].should equal(mock_publication)
      end

      it "re-renders the 'edit' template" do
        Oktopartial::Publication.stub!(:find).and_return(mock_publication(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested publication" do
      Oktopartial::Publication.should_receive(:find).with("37").and_return(mock_publication)
      mock_publication.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the oktopartial_publications list" do
      Oktopartial::Publication.stub!(:find).and_return(mock_publication(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(:controller => 'oktopartial/publications', :action => :index)
    end
  end

end
