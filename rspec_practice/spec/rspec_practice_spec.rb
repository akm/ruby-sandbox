require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "hook block" do
  class A
    def foo(*args)
    end
  end

  before do
    @results = []
    @proc1 = Proc.new{|*args| @results << args}
  end

  case RSpec::Version::STRING
  when /^2\.6\.|^2\.7\.|^2\.8\./ then

    context "using 'with'" do
      it "as a block " do
        A.stub(:foo).with("bar") do |s, &block|
          block.should == nil
        end
        A.foo("bar", &@proc1)
      end

      it "not as a block " do
        A.stub(:foo).with("bar") do |s, block|
          block.should == @proc1
        end
        A.foo("bar", &@proc1)
      end
    end

    context "stub only" do
      it "as a block " do
        A.stub(:foo) do |s, &block|
          s.should == "bar"
          block.should == nil
        end
        A.foo("bar", &@proc1)
      end

      it "not as a block " do
        A.stub(:foo) do |s, block|
          s.should == "bar"
          block.should == @proc1
        end
        A.foo("bar", &@proc1)
      end
    end


  when /^2\.9\.|^2\.10\./ then

    context "using 'with'" do
      it "as a block " do
        A.stub(:foo).with("bar") do |s, &block|
          block.should == @proc1
        end
        A.foo("bar", &@proc1)
      end

      it "not as a block " do
        A.stub(:foo).with("bar") do |s, block|
          block.should == nil
        end
        A.foo("bar", &@proc1)
      end
    end

    context "stub only" do
      it "as a block " do
        A.stub(:foo) do |s, &block|
          s.should == "bar"
          block.should == @proc1
        end
        A.foo("bar", &@proc1)
      end

      it "not as a block " do
        A.stub(:foo) do |s, block|
          s.should == "bar"
          block.should == nil
        end
        A.foo("bar", &@proc1)
      end
    end


  end
end
