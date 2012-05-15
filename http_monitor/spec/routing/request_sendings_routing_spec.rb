require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RequestSendingsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "request_sendings", :action => "index").should == "/request_sendings"
    end
  
    it "maps #new" do
      route_for(:controller => "request_sendings", :action => "new").should == "/request_sendings/new"
    end
  
    it "maps #show" do
      route_for(:controller => "request_sendings", :action => "show", :id => "1").should == "/request_sendings/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "request_sendings", :action => "edit", :id => "1").should == "/request_sendings/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "request_sendings", :action => "create").should == {:path => "/request_sendings", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "request_sendings", :action => "update", :id => "1").should == {:path =>"/request_sendings/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "request_sendings", :action => "destroy", :id => "1").should == {:path =>"/request_sendings/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/request_sendings").should == {:controller => "request_sendings", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/request_sendings/new").should == {:controller => "request_sendings", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/request_sendings").should == {:controller => "request_sendings", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/request_sendings/1").should == {:controller => "request_sendings", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/request_sendings/1/edit").should == {:controller => "request_sendings", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/request_sendings/1").should == {:controller => "request_sendings", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/request_sendings/1").should == {:controller => "request_sendings", :action => "destroy", :id => "1"}
    end
  end
end
