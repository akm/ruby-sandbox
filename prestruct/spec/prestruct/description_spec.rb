# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

require File.dirname(__FILE__) + '/../resources/root'
require File.dirname(__FILE__) + '/../resources/leaf'

describe Prestruct::ModuleDescription do

  describe "method_descriptions" do
    before(:each) do
      @leaf_desciption = Leaf.prestruct
      @hoge_desciption = @leaf_desciption.method_descriptions[:hoge]
    end
    
    it "get unexist attr" do
      @hoge_desciption[nil].should == nil
      @hoge_desciption[''].should == nil
      @hoge_desciption['unexist'].should == nil
    end
    
    it "get method extra attrs" do
      @hoge_desciption[:name].should == "ほげ"
      @hoge_desciption[:hidden].should == true
    end
  end
  
end
