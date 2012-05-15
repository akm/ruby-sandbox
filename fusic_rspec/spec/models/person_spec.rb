# -*- coding: utf-8 -*-
require 'spec_helper'

describe Person do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe :hirata_list, "hirataと名のつく人をリストアップする" do
    before do
      Person.create(:name => "hirata pudding")
      Person.create(:name => "hirano pudding")
    end

    it "hiranoさんはリストアップしない" do
      result = Person.hirata_list
      result.map(&:name).should == ['hirata pudding']
    end

    it "hirataさんが3人いる場合は、名前でソートしたものを返すべき" do
      Person.create(:name => "hirata pudding3")
      Person.create(:name => "hirata pudding2")
      result = Person.hirata_list
      result.map(&:name).should == ['hirata pudding', "hirata pudding2", "hirata pudding3", ]
    end
  end

  describe :puddingized_name, "プリン化された名前" do
    it "nameの後ろに'_pudding'を付ける" do
      tokyo = Person.new(:name => "Tokyo")
      tokyo.puddingized_name.should == "Tokyo_pudding"
    end
  end

  describe :age, "年齢を返します" do
    it "1980/01/29生まれのhirataさんは30才" do
      hirata = Person.new(:name => "hirata", :birthday => Date.new(1980, 1, 29))
      hirata.age.should == 30
    end
  end


end
