# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), '../spec_helper')
require 'fileutils'

describe DirFixtures::Fixture do
  
  before(:each) do
    @work_dir = File.expand_path(
      File.join(File.dirname(__FILE__), '../../spec_work', 
        File.basename(__FILE__, '.*')))
    FileUtils.rm_rf(@work_dir) if File.exist?(@work_dir)
    FileUtils.mkdir_p(@work_dir)
    FileUtils.cd(@work_dir) do
      FileUtils.mkdir_p('fixtures/fixture1/foo/bar/baz')
      FileUtils.mkdir_p('fixtures/fixture2/foo')
      FileUtils.touch('fixtures/test0.txt')
      FileUtils.touch('fixtures/fixture1/test1.txt')
      FileUtils.touch('fixtures/fixture1/foo/test2.txt')
      FileUtils.touch('fixtures/fixture1/foo/bar/test3.txt')
      FileUtils.touch('fixtures/fixture1/foo/bar/baz/test4.txt')
      FileUtils.touch('fixtures/fixture2/test5.txt')
      FileUtils.touch('fixtures/fixture2/foo/test6.txt')
      FileUtils.rm_rf('target') if File.exist?('target')
      FileUtils.mkdir_p('target')
    end
  end

  describe "setup" do
    it "without protected_paths" do
      target_dir = File.join(@work_dir, 'target')
      Dir.chdir(target_dir) do
        Dir['*', '*.*', '.*'].should == %w(. ..)
      end

      DirFixtures::Fixture.setup(target_dir, File.join(@work_dir, 'fixtures/fixture1'))
      
      Dir.chdir(target_dir) do
        File.exist?('test1.txt').should == true
        File.exist?('foo/test2.txt').should == true
        File.exist?('foo/bar/test3.txt').should == true
        File.exist?('foo/bar/baz/test4.txt').should == true
        File.exist?('test5.txt').should == false
        File.exist?('foo/test6.txt').should == false
      end

      DirFixtures::Fixture.setup(target_dir, File.join(@work_dir, 'fixtures/fixture2'))
      
      Dir.chdir(target_dir) do
        File.exist?('test1.txt').should == true
        File.exist?('foo/test2.txt').should == true
        File.exist?('foo/bar/test3.txt').should == true
        File.exist?('foo/bar/baz/test4.txt').should == true
        File.exist?('test5.txt').should == true
        File.exist?('foo/test6.txt').should == true
      end

    end

    describe "with protected_paths" do
      it "no ProtectViolation" do
        target_dir = File.join(@work_dir, 'target')
        Dir.chdir(target_dir) do
          Dir['*', '*.*', '.*'].should == %w(. ..)
          FileUtils.mkdir_p('foo/hoge/fuga')
          FileUtils.touch('foo/hoge/fuga/untouchable1.txt')
        end

        DirFixtures::Fixture.setup(target_dir, File.join(@work_dir, 'fixtures/fixture1'),
          :protected_paths => ['foo/hoge/fuga'])
        Dir.chdir(target_dir) do
          File.exist?('test1.txt').should == true
          File.exist?('foo/test2.txt').should == true
          File.exist?('foo/bar/test3.txt').should == true
          File.exist?('foo/bar/baz/test4.txt').should == true
          File.exist?('test5.txt').should == false
          File.exist?('foo/test6.txt').should == false
          # :protected_paths で指定されたディレクトリ／ファイルは残ります
          File.exist?('foo/hoge/fuga/untouchable1.txt').should == true
        end

        DirFixtures::Fixture.setup(target_dir, File.join(@work_dir, 'fixtures/fixture2'))
        Dir.chdir(target_dir) do
          File.exist?('test1.txt').should == true
          File.exist?('foo/test2.txt').should == true
          File.exist?('foo/bar/test3.txt').should == true
          File.exist?('foo/bar/baz/test4.txt').should == true
          File.exist?('test5.txt').should == true
          File.exist?('foo/test6.txt').should == true
          # :protected_paths で指定されたディレクトリ／ファイルは残ります
          File.exist?('foo/hoge/fuga/untouchable1.txt').should == true
        end
      end
      it "no ProtectViolation" do
        target_dir = File.join(@work_dir, 'target')
        Dir.chdir(target_dir) do
          Dir['*', '*.*', '.*'].should == %w(. ..)
          FileUtils.mkdir_p('foo/hoge/fuga')
          FileUtils.touch('foo/hoge/fuga/untouchable1.txt')
        end

        DirFixtures::Fixture.setup(target_dir, File.join(@work_dir, 'fixtures/fixture1'),
          :protected_paths => ['foo/hoge/fuga'])
        Dir.chdir(target_dir) do
          File.exist?('test1.txt').should == true
          File.exist?('foo/test2.txt').should == true
          File.exist?('foo/bar/test3.txt').should == true
          File.exist?('foo/bar/baz/test4.txt').should == true
          File.exist?('test5.txt').should == false
          File.exist?('foo/test6.txt').should == false
          # :protected_paths で指定されたディレクトリ／ファイルは残ります
          File.exist?('foo/hoge/fuga/untouchable1.txt').should == true
        end

        DirFixtures::Fixture.setup(target_dir, File.join(@work_dir, 'fixtures/fixture2'))
        Dir.chdir(target_dir) do
          File.exist?('test1.txt').should == true
          File.exist?('foo/test2.txt').should == true
          File.exist?('foo/bar/test3.txt').should == true
          File.exist?('foo/bar/baz/test4.txt').should == true
          File.exist?('test5.txt').should == true
          File.exist?('foo/test6.txt').should == true
          # :protected_paths で指定されたディレクトリ／ファイルは残ります
          File.exist?('foo/hoge/fuga/untouchable1.txt').should == true
        end
      end

      it "with ProtectViolation" do
        target_dir = File.join(@work_dir, 'target')
        Dir.chdir(target_dir) do
          Dir['*', '*.*', '.*'].should == %w(. ..)
          FileUtils.mkdir_p('foo/bar/baz')
          FileUtils.touch('foo/bar/baz/untouchable1.txt')
        end

        lambda{
          DirFixtures::Fixture.setup(target_dir, 
            File.join(@work_dir, 'fixtures/fixture1'),
            :protected_paths => ['foo/bar/baz'])
        }.should raise_error(DirFixtures::ProtectViolationError)
      end
    end
  end

end
