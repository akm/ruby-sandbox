require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Oktopartial::PublicationsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "oktopartial/publications", :action => "index").should == "/oktopartial/publications"
    end

    it "maps #new" do
      route_for(:controller => "oktopartial/publications", :action => "new").should == "/oktopartial/publications/new"
    end

    it "maps #show" do
      route_for(:controller => "oktopartial/publications", :action => "show", :id => "1").should == "/oktopartial/publications/1"
    end

    it "maps #edit" do
      route_for(:controller => "oktopartial/publications", :action => "edit", :id => "1").should == "/oktopartial/publications/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "oktopartial/publications", :action => "create").should == {:path => "/oktopartial/publications", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "oktopartial/publications", :action => "update", :id => "1").should == {:path =>"/oktopartial/publications/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "oktopartial/publications", :action => "destroy", :id => "1").should == {:path =>"/oktopartial/publications/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/oktopartial/publications").should == {:controller => "oktopartial/publications", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/oktopartial/publications/new").should == {:controller => "oktopartial/publications", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/oktopartial/publications").should == {:controller => "oktopartial/publications", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/oktopartial/publications/1").should == {:controller => "oktopartial/publications", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/oktopartial/publications/1/edit").should == {:controller => "oktopartial/publications", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/oktopartial/publications/1").should == {:controller => "oktopartial/publications", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/oktopartial/publications/1").should == {:controller => "oktopartial/publications", :action => "destroy", :id => "1"}
    end
  end
end
