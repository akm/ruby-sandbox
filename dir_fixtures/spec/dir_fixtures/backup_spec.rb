# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), '../spec_helper')
require 'fileutils'

describe DirFixtures::Backup do
  
  before(:each) do
    DirFixtures::Backup.instance_variable_set(:@instances, nil)
    @work_dir = File.join(File.dirname(__FILE__), '../../spec_work', 
      File.basename(__FILE__, '.*'))
    FileUtils.rm_rf(@work_dir) if File.exist?(@work_dir)
    FileUtils.mkdir_p(@work_dir)
    Dir.chdir(@work_dir) do
      FileUtils.mkdir_p('target/foo/bar/baz')
      FileUtils.touch('test0.txt')
      FileUtils.touch('target/test1.txt')
      FileUtils.touch('target/foo/test2.txt')
      FileUtils.touch('target/foo/bar/test3.txt')
      FileUtils.touch('target/foo/bar/baz/test4.txt')
      FileUtils.rm_rf('backup') if File.exist?('backup')
      FileUtils.mkdir_p('backup')
    end
  end

  describe "transaction" do

    it "without cache" do
      target_dir = File.join(@work_dir, 'target')
      backup_dir = File.join(@work_dir, 'backup', 'target')
      DirFixtures::Backup.transaction(target_dir, :dir => File.join(@work_dir, 'backup')) do
        File.exist?(backup_dir).should == true
        # バックアップが取れていることを確認
        Dir.chdir(backup_dir) do
          File.exist?('test1.txt').should == true
          File.exist?('foo/test2.txt').should == true
          File.exist?('foo/bar/test3.txt').should == true
          File.exist?('foo/bar/baz/test4.txt').should == true
        end
        # 対象内を操作してバックアップと内容を変更する
        Dir.chdir(target_dir) do
          FileUtils.rm('foo/test2.txt')
          FileUtils.rm('foo/bar/test3.txt')

          File.exist?('foo/test2.txt').should == false
          File.exist?('foo/bar/test3.txt').should == false

          FileUtils.mkdir_p('bar')
          FileUtils.touch('bar/test5.txt')
          FileUtils.touch('test6.txt')
        end
      end

      Dir.chdir(target_dir) do
        File.exist?('test1.txt').should == true
        File.exist?('foo/test2.txt').should == true
        File.exist?('foo/bar/test3.txt').should == true
        File.exist?('foo/bar/baz/test4.txt').should == true
        File.exist?('bar/test5.txt').should == false
        File.exist?('test6.txt').should == false
      end
    end

    it "backup dir already exists" do
      target_dir = File.join(@work_dir, 'target')
      backup_dir = File.join(@work_dir, 'backup', 'target')

      # ダミーのバックアップキャッシュを作っておく
      Dir.chdir(File.join(@work_dir, 'backup')) do
        FileUtils.mkdir_p('target')
        FileUtils.touch('target/test1.txt')
      end
      # キャッシュがある状態でtransactionをcache=>nilで実行します。
      lambda{
        DirFixtures::Backup.transaction(target_dir, :dir => File.join(@work_dir, 'backup'))
      }.should raise_error(DirFixtures::BackupError)
      
    end

    it "with cache" do
      target_dir = File.join(@work_dir, 'target')
      backup_dir = File.join(@work_dir, 'backup', 'target')

      # ダミーのバックアップキャッシュを作っておく
      Dir.chdir(File.join(@work_dir, 'backup')) do
        FileUtils.mkdir_p('target')
        FileUtils.touch('target/test1.txt')
      end
      
      DirFixtures::Backup.transaction(target_dir, :dir => File.join(@work_dir, 'backup'), :cache => true) do
        # 対象内を操作してバックアップと内容を変更する
        Dir.chdir(target_dir) do
          FileUtils.mkdir_p('bar')
          FileUtils.touch('bar/test5.txt')
          FileUtils.touch('test6.txt')
        end
      end

      Dir.chdir(target_dir) do
        File.exist?('test1.txt').should == true
        File.exist?('bar').should == false
        File.exist?('bar/test5.txt').should == false
        File.exist?('test6.txt').should == false
      end
    end
  end
  
  
end
