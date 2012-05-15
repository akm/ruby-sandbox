unless Module.constants.include?('Tracer')
  module ObjectSpace
    class << self
      def all_modules(klass = nil)
        result = []
        each_object(klass || Module) do |obj| 
          result << obj if !block_given? || yield(obj)
        end
        result
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

  module Tracer
    class Dependency
      def self.instances
        @@instances ||= []
      end
      
      attr_reader :source, :method, :feature, :called_place, :no_loading
      attr_reader :index
      def initialize(source, method, feature, called_place, no_loading)
        @source, @method, @feature, @called_place, @no_loading = 
          source, method, feature, called_place, no_loading
        @index = self.class.instances.length
        self.class.instances << self
      end
    end
    
    class Feature
      attr_reader :name
      def initialize(name)
        @name = name
      end

      def dependencies
        @dependencies ||= []
      end
      
      def referreds
        @referreds ||= []
      end

      def modules
        @modules ||= []
      end
      def modules=(value)
        @modules = value
      end
      
      def path
        $LOAD_PATH.each do |load_path|
          result = File.join(load_path, name)
          result << '.rb' unless /\.rb$/ =~ result
          return result if File.exist?(result)
        end
        null
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
        loaded_feature = features[feature_name]
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

      def features
        @features ||= {}
      end
      
      def new_feature(name)
        features[name] ||= Feature.new(name)
        features[name]
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
      
    end
  end
  
  module Kernel
    alias load_without_tracer load
    alias require_without_tracer require
    
    def load(file, priv = false)
      Tracer.new_dependency(file, :load) do 
        load_without_tracer(file, priv)
      end
    end
    
    def require(feature)
      Tracer.new_dependency(feature, :require) do 
        require_without_tracer(feature)
      end
    end
  end

end

