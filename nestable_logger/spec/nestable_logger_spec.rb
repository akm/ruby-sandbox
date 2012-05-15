# -*- coding: utf-8 -*-
require File.expand_path('./spec_helper', File.dirname(__FILE__))

require 'logger'
require 'stringio'

describe NestableLogger do

  class TestLogger
    attr_reader :logs
    def initialize
      @logs = []
    end

    def debug(msg)
      @logs << msg
    end
  end

  class Target1

    attr_reader :logger
    def initialize(logger)
      @logger = logger
    end

    def foo
      logger.debug_method(self, "foo") do
        logger.debug_index do
          logger.debug_index("abc")
          # puts "foo1"
          logger.debug_index
          "FOO" # 最後の評価が戻り値になる
        end
      end
    end

    def bar
      logger.debug_method(self) do # メソッド名が自動補完される
        logger.debug_index do
          logger.debug("abc")
          # puts "foo1"
          logger.debug("www")
          "BAR" # 最後の評価が戻り値になる
        end
      end
    end

    def hook_error_and_raise_it
      logger.debug_method(self, "foo") do
        logger.debug_index do
          raise StandardError, "Some exception occured"
        end
      end
    end

  end

  describe :options do
    before do
      @impl = Logger.new(STDOUT)
      @logger = NestableLogger.new(@impl)
    end

    it "何も設定しなくてもオプションは取得できる" do
      @logger.options.should == {
      }
    end
  end

  describe :logging do
    before do
      @impl = TestLogger.new
      @logger = NestableLogger.new(@impl)
    end

    context "nested call" do
      it "foo" do
        @target1 = Target1.new(@logger)
        @target1.foo.should == "FOO" # ちゃんと戻り値が返ってくる
        @impl.logs.should == [
          "Target1#foo S"      ,
          "Target1#foo.1 S"    ,
          "Target1#foo.1.1 abc",
          "Target1#foo.1.2"    ,
          "Target1#foo.1 E"    ,
          "Target1#foo E"      ,
        ]
      end

      it "bar" do
        @target1 = Target1.new(@logger)
        @target1.bar.should == "BAR" # ちゃんと戻り値が返ってくる
        @impl.logs.should == [
          "Target1#bar S"      ,
          "Target1#bar.1 S"    ,
          "abc"  ,
          "www"  ,
          "Target1#bar.1 E"    ,
          "Target1#bar E"      ,
        ]
      end
    end

    it "error log" do
      @target1 = Target1.new(@logger)
      lambda{
        @target1.hook_error_and_raise_it
      }.should raise_error(StandardError)
      @impl.logs[0].should == "Target1#foo S"
      @impl.logs[1].should == "Target1#foo.1 S"
      error_lines = @impl.logs[2].split(/$/).map{|line| line.strip}
      error_lines[0].should == "Target1#foo.1 ERROR"
      error_lines[1].should == "[StandardError] Some exception occured"
    end
  end

end
