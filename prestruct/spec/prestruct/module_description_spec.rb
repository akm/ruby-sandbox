# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

require File.dirname(__FILE__) + '/../resources/root'
require File.dirname(__FILE__) + '/../resources/leaf'

describe Prestruct::ModuleDescription do

  describe "method_descriptions" do
    before(:each) do
      @leaf_desciption = Leaf.prestruct
    end
    
    it "get extra attrs for unexist method" do
      @leaf_desciption.method_descriptions[nil].should == nil
      @leaf_desciption.method_descriptions[''].should == nil
      @leaf_desciption.method_descriptions['unexist_method'].should == nil
    end
    
    it "get method extra attrs" do
      @leaf_desciption.method_descriptions[:hoge][:name].should == "ほげ"
      @leaf_desciption.method_descriptions[:hoge][:hidden].should == true
      # 
      @leaf_desciption.method_descriptions[:hage][:auth_as].should == "hoge"
    end
  end
  
end
