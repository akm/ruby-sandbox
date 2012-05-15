# -*- coding: utf-8 -*-
unless Module.constants.include?('Endoscope')
puts "endo_scope.rb loading..."
begin
  module ObjectSpace
    class << self
      def all_modules(klass = nil)
        klass ||= Module
        result = []
        if block_given?
          each_object(klass){|obj| result << obj if yield(obj) }
        else
          each_object(klass){|obj| result << obj }
        end
        result
      end
      
      def all_modules_except_class
        if block_given?
          all_modules(Module){|m| !m.is_a?(Class) && yield(m)}
        else
          all_modules(Module){|m| !m.is_a?(Class)}
        end
      end

      def find_by_name(name, klass = nil)
        each_object(klass || Module) do |obj| 
          return obj if obj.name == name
        end
        return nil
      end
      
      def detect(object_id, klass = nil)
        each_object(klass || Module) do |obj| 
          return obj if obj.object_id == object_id
        end
        return nil
      end
    end
  end

  module Endoscope
    class Dependency
      def self.instances
        @@instances ||= []
      end
      
      attr_reader :source, :method, :feature, :called_place, :no_loading
      attr_reader :index
      def initialize(source, method, feature, called_place, no_loading)
        @source, @method, @feature, @called_place, @no_loading = 
          source, method, feature, ::Endoscope.security_mask(called_place), no_loading
        @index = self.class.instances.length
        self.class.instances << self
      end
    end
    
    class Feature
      def self.instances
        @instances ||= []
      end
      def self.name_to_instance
        @name_to_instance ||= { }
      end

      def self.find_by_name(name)
        
      end

      attr_reader :name, :real_path, :display_path
      attr_reader :index
      alias_method :path, :display_path
      def initialize(name)
        @index = self.class.instances.length
        self.class.instances << self
        self.class.name_to_instance[name] = self
        @real_path = find_exist_path(name)
        unless @real_path
          $LOAD_PATH.each do |load_path|
            @real_path = find_exist_path(File.join(load_path, name))
            break if @real_path
          end
        end
        @display_path = ::Endoscope.security_mask(@real_path)
        @name = ::Endoscope.security_mask(name)
        @human_readable = @real_path && @real_path =~ /\.rb$/
      end

      def dependencies; @dependencies ||= []; end
      def referreds; @referreds ||= []; end

      def modules; @modules ||= []; end
      def modules=(value); @modules = value; end
      
      def human_readable?; @human_readable; end

      private
      
      EXT_SUGGESTS = %w(.rb .so .bundle)

      def find_exist_path(src)
        return src if File.exist?(src) && !File.directory?(src)
        EXT_SUGGESTS.each do |ext|
          filename = "#{src}#{ext}"
          return filename if File.exist?(filename) && !File.directory?(filename)
        end
        nil
      end
    end
    
    class << self
      def setup(feature_name)
        @current_feature = new_feature(feature_name)
        @last_loded_modules = ObjectSpace.all_modules
      end
      
      REQUIRE_FILTER = /require\'$|\`new_dependency\'$|new_constants_in\'$|\`load_file\'$|\`require_library_or_gem\'$|reporting.rb\:\d+\:in \`silence_warnings\'$/o
      
      def caller_place
        caller.detect{|line| REQUIRE_FILTER !~ line}
      end
      
      def new_dependency(feature_name, method)
        append_loaded_modules
        this_feature = @current_feature
        loaded_feature = Feature.find_by_name(feature_name)
        @current_feature = new_feature(feature_name)
        dependency = Dependency.new(this_feature, method, @current_feature, caller_place, (method == :require) && !!loaded_feature)

        this_feature.dependencies << dependency
        @current_feature.referreds << dependency
        begin
          return yield if block_given?
        ensure
          append_loaded_modules
          @current_feature = this_feature
        end
      end

      def new_feature(name)
        Feature.new(name)
      end

      def append_loaded_modules
        loaded_modules = ObjectSpace.all_modules
        diff = loaded_modules - @last_loded_modules
        @current_feature.modules += diff
        @last_loded_modules = loaded_modules
        diff.each{|d| add_class_to_features(d)}
        diff
      end
      
      def class_to_features
        @class_to_features ||= {}
      end
      
      def add_class_to_features(klass)
        class_to_features[klass] ||= []
        class_to_features[klass] << @current_feature 
      end
      
      # 公開した時のセキュリティの為にホームディレクトリは隠します
      def security_mask(filename)
        filename.nil? ? nil : filename.gsub(/^\/(Users|home)\/[\w\d\_\-]+?\//, '~/')
      end

      def all_modules(*args, &block)
        ObjectSpace.all_modules(*args, &block)
      end
      
      def all_modules_except_class(*args, &block)
        ObjectSpace.all_modules_except_class(*args, &block)
      end
      
      def find_by_name(*args, &block)
        ObjectSpace.find_by_name(*args, &block)
      end
      
      def detect(*args, &block)
        ObjectSpace.detect(*args, &block)
      end

      def each_object(*args, &block)
        ObjectSpace.each_object(*args, &block)
      end
    end
  end
  
  module Kernel
    alias load_without_tracer load
    alias require_without_tracer require
    
    def load(file, priv = false)
      Endoscope.new_dependency(file, :load) do 
        load_without_tracer(file, priv)
      end
    end
    
    def require(feature)
      Endoscope.new_dependency(feature, :require) do 
        require_without_tracer(feature)
      end
    end
  end

rescue Exception => e
  puts e
  puts e.backtrace.join("\n  ")
ensure
  puts "endo_scope.rb loaded finally"
end
end

