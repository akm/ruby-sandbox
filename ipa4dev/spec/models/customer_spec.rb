# -*- coding: utf-8 -*-
require 'spec_helper'

describe Customer do
  describe :csv_export do
    before do
      Customer.create!(:customer_code => "00001", :name => "MTT DATA")
      Customer.create!(:customer_code => "00002", :name => "SOMY")
      Customer.create!(:customer_code => "00003", :name => "SOFTBAMK")
    end

    it "レコードをすべて出力する" do
      mock_f = mock(:file)
      filepath = Rails.root.join("tmp/test1.csv")
      File.should_receive(:open).with(filepath, "w").and_yield(mock_f)
      mock_f.should_receive(:puts).with("00001,MTT DATA")
      mock_f.should_receive(:puts).with("00002,SOMY")
      mock_f.should_receive(:puts).with("00003,SOFTBAMK")
      Customer.csv_export
    end
  end
end
