require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RequestSending do
  before(:each) do
    @valid_attributes = {
      :method => "value for method",
      :uri => "value for uri",
      :parameters => "value for parameters",
      :headers => "value for headers"
    }
  end

  it "should create a new instance given valid attributes" do
    RequestSending.create!(@valid_attributes)
  end
end
