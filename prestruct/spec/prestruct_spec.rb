# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

require File.dirname(__FILE__) + '/resources/root'
require File.dirname(__FILE__) + '/resources/leaf'

describe Prestruct do
  
  describe "Prestruct.[]" do
    it "try to get for nil" do
      Prestruct[nil].should == nil
      Prestruct[''].should == nil
      Prestruct['unexist'].should == nil
    end

    it "get ModuleDescription for Root" do
      root_desciption = Prestruct[:Root]
      root_desciption.class.should == Prestruct::ModuleDescription
      root_desciption.name.should == 'Root'
      root_desciption[:name].should == "根っこ"
      Prestruct[Root].should == root_desciption
      Prestruct['Root'].should == root_desciption
    end

    it "get ModuleDescription for Leaf" do
      leaf_description = Prestruct[:Leaf]
      leaf_description.class.should == Prestruct::ModuleDescription
      leaf_description.name.should == 'Leaf'
      leaf_description[:name].should == "葉っぱ"
      Prestruct[Leaf].should == leaf_description
      Prestruct['Leaf'].should == leaf_description
    end
  end

  describe "Prestruct::ClassMethods#prestruct" do
    it "should return same object as Prestruct.[]" do
      Root.prestruct.should == Prestruct[:Root]
      Leaf.prestruct.should == Prestruct[:Leaf]
    end
  end

  describe "export" do
    it "for descendant classes" do
      Prestruct.export(Root).should == {
        'Root' => {
          'name' => "根っこ"
        },
        "Leaf" => {
          'name' => "葉っぱ",
          'methods' => {
            'hoge' => {
              'name' => "ほげ",
              'hidden' => true
            },
            'hage' => {
              'auth_as' => "hoge"
            }
          }
        }
      }
    end

    it "without descendant classes" do
      Prestruct.export(Root, :except_descendants => true).should == {
        'Root' => {
          'name' => "根っこ"
        }
      }
    end
  end

  describe "build" do
    before(:each) do
      @source = {
        'Node1' => {
          'name' => "ノード１"
        },
        "Node2" => {
          'name' => "ノード２",
          'methods' => {
            'hoge' => {
              'name' => "ほげ",
              'hidden' => true
            },
            'hage' => {
              'auth_as' => "hoge"
            }
          }
        }
      }
    end

    it "build with String key" do
      result = Prestruct.build(@source)
      node1_description = result['Node1']
      node2_description = result['Node2']
      Prestruct['Node1'].should == nil
      Prestruct['Node2'].should == nil
      Prestruct[:Node1].should == nil
      Prestruct[:Node2].should == nil
      node1_description.should_not be_nil
      node2_description.should_not be_nil
      node1_description[:name].should == 'ノード１'
      node2_description[:name].should == 'ノード２'
      hoge_description = node2_description.method_descriptions[:hoge]
      hoge_description.should_not be_nil
      hoge_description[:name].should == 'ほげ'
      hoge_description[:hidden].should == true
      hage_description = node2_description.method_descriptions[:hage]
      hage_description.should_not be_nil
      hage_description[:auth_as].should == "hoge"
    end

    it "build with Symbol key" do
      source = {
        :Node1 => @source['Node1'],
        :Node2 => @source['Node2']
      }
      result = Prestruct.build(source)
      node1_description = result[:Node1]
      node2_description = result[:Node2]
      Prestruct['Node1'].should == nil
      Prestruct['Node2'].should == nil
      Prestruct[:Node1].should == nil
      Prestruct[:Node2].should == nil
      node1_description.should_not be_nil
      node2_description.should_not be_nil
      node1_description[:name].should == 'ノード１'
      node2_description[:name].should == 'ノード２'
      hoge_description = node2_description.method_descriptions[:hoge]
      hoge_description.should_not be_nil
      hoge_description[:name].should == 'ほげ'
      hoge_description[:hidden].should == true
      hage_description = node2_description.method_descriptions[:hage]
      hage_description.should_not be_nil
      hage_description[:auth_as].should == "hoge"
    end
  end

end
