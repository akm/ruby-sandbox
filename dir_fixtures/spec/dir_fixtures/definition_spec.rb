require File.join(File.dirname(__FILE__), '../spec_helper')

describe DirFixtures::Definition do

  before(:each) do
    DirFixtures.instance_variable_set(:@definitions, nil)
    DirFixtures.define('test/fixtures/publics') do |d|
      d.target 'public'
      d.protect %w(javascripts images/default)
      d.protect 'stylesheets', 'system'
    end
  end

  describe "target" do
    it "should return destination path to copy fixtures" do
      DirFixtures['test/fixtures/publics'].target.should == 'public'
    end
  end

  describe "protected_paths" do
    it "should return paths" do
      DirFixtures['test/fixtures/publics'].protected_paths.should == %w(javascripts images/default stylesheets system)
    end
  end

  describe "process" do
    it "should backup target and load fixture" do
      DirFixtures::Backup.should_receive(:transaction).
        with('public', :cache => nil).once.and_yield
      
      DirFixtures::Fixture.should_receive(:setup).
        with('test/fixtures/publics/public1', :protected_paths => %w(javascripts images/default stylesheets system)).once

      block_called_count = 0
      DirFixtures['test/fixtures/publics'].process('public1') do 
        block_called_count += 1
      end
      block_called_count.should == 1
    end
    
  end



end
