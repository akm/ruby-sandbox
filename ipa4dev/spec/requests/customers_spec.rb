# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Customers" do
  describe "GET /customers" do
    it "works! (now write some real specs)" do
      get customers_path
    end
  end

  describe "POST /customers" do
    it "JSONで登録" do
      Customer.delete_all
      lambda{
        post "/customers.json", :customer => {:name => "David", :customer_code => "000001"}
      }.should change(Customer, :count).by(1)
      response.should be_success
      actual_result = JSON.parse(response.body)
      customer = actual_result['customer']
      customer['id'].should be_kind_of(Integer)
      customer['name'].should == "David"
      customer['customer_code'].should == "000001"
    end
  end

end
