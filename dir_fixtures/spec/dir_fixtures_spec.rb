require File.join(File.dirname(__FILE__), 'spec_helper')

describe DirFixtures do
  
  before(:each) do
    DirFixtures.instance_variable_set(:@definitions, nil)
  end

  describe 'define' do
    it "should add a definition" do
      DirFixtures.define('parent/dir/of/fixture/directories')
      DirFixtures.definitions.length.should == 1
      definition = DirFixtures['parent/dir/of/fixture/directories']
      definition.should_not be_nil
      definition.root_path.should == 'parent/dir/of/fixture/directories'
    end
  end

  describe 'get definition' do
    it "definitions" do
      DirFixtures.define('dir1')
      DirFixtures.define('dir2')
      DirFixtures.definitions.length.should == 2
      DirFixtures.definitions['dir1'].should_not be_nil
      DirFixtures.definitions['dir2'].should_not be_nil
      DirFixtures.definitions['unexist/dir'].should be_nil
    end

    it "[] should raise Error for unexist dir" do
      DirFixtures.define('dir1')
      DirFixtures.define('dir2')
      DirFixtures.definitions.length.should == 2
      DirFixtures['dir1'].should_not be_nil
      DirFixtures['dir2'].should_not be_nil
      lambda{ DirFixtures['unexist/dir'] }.should raise_error(DirFixtures::NoDefinitionError)
    end
  end
  
end
