# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Oktopartial::Publication do
  before(:each) do
    @valid_attributes = {
      :uploaded_file => mock(:file, :original_path => "aaa.zip", :read => ''),
      :source_path => "site_renewal.zip",
      :dirname => "20091006095300-site_renewal",
      :published_at => Time.now,
      :status_cd => '0'
    }
  end

  it "should create a new instance given valid attributes" do
    Oktopartial::Publication.create!(@valid_attributes)
  end

  describe "status_cd" do
    it "STATUS_CD_OPTIONS" do
      Oktopartial::Publication::STATUS_CD_OPTIONS.should == [
        ['公開準備中'    , '0'],
        ['公開準備エラー', '1'],
        ['公開待ち'      , '2'],
        ['公開中'        , '3'],
        ['公開済み'      , '4'],
        ['公開エラー'    , '5']
      ]
    end

    it "status_key" do
      pub1 = Oktopartial::Publication.new
      pub1.status_key.should == :preparing
      pub1.status_cd = '0'; pub1.status_key.should == :preparing
      pub1.status_cd = '1'; pub1.status_key.should == :preparation_error
      pub1.status_cd = '2'; pub1.status_key.should == :staging
      pub1.status_cd = '3'; pub1.status_key.should == :publishing
      pub1.status_cd = '4'; pub1.status_key.should == :published
      pub1.status_cd = '5'; pub1.status_key.should == :publishing_error
      pub1.status_cd = '6'; pub1.status_key.should == nil
      pub1.status_cd = nil; pub1.status_key.should == nil
    end
    
    it "status_key=" do
      pub1 = Oktopartial::Publication.new
      pub1.status_key.should == :preparing
      pub1.status_key = :preparing        ; pub1.status_cd.should == '0'
      pub1.status_key = :preparation_error; pub1.status_cd.should == '1'
      pub1.status_key = :staging          ; pub1.status_cd.should == '2'
      pub1.status_key = :publishing       ; pub1.status_cd.should == '3'
      pub1.status_key = :published        ; pub1.status_cd.should == '4'
      pub1.status_key = :publishing_error ; pub1.status_cd.should == '5'
      pub1.status_key = :unexist_key      ; pub1.status_cd.should == nil
    end
    
    it "status_key" do
      pub1 = Oktopartial::Publication.new
      pub1.status_key.should == :preparing
      pub1.status_cd = '0'; pub1.status_name.should == '公開準備中'
      pub1.status_cd = '1'; pub1.status_name.should == '公開準備エラー'
      pub1.status_cd = '2'; pub1.status_name.should == '公開待ち'
      pub1.status_cd = '3'; pub1.status_name.should == '公開中'
      pub1.status_cd = '4'; pub1.status_name.should == '公開済み'
      pub1.status_cd = '5'; pub1.status_name.should == '公開エラー'
      pub1.status_cd = '6'; pub1.status_name.should == nil
      pub1.status_cd = nil; pub1.status_name.should == nil
    end
    
  end
  
end
