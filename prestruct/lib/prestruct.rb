module Prestruct
  autoload :Description, 'prestruct/description'
  autoload :ModuleDescription, 'prestruct/module_description'
  autoload :MethodDescription, 'prestruct/method_description'

  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    def prestruct
      Prestruct[self]
    end
    
    def module_desc(meta_attrs = nil)
      description = Prestruct.find_or_new_module(self)
      description.update(meta_attrs)
      description
    end
    alias_method :class_desc, :module_desc

    def desc(meta_attrs)
      @last_descriptions = meta_attrs
    end

    def method_added(method)
      return unless @last_descriptions
      module_description = Prestruct.find_or_new_module(self)
      method_description = module_description.find_or_new_method(method)
      method_description.update(@last_descriptions)
      method_description
    end
  end

  class << self
    def [](module_or_name)
      modules[to_module_name(module_or_name)]
    end

    def find_or_new_module(module_or_name)
      name = to_module_name(module_or_name)
      unless result = modules[name]
        modules[name] = result = ModuleDescription.new(name)
      end
      result
    end

    def modules
      @modules ||= {}
    end

    def to_module_name(module_or_name)
      if module_or_name.is_a?(Module)
        module_or_name.name.to_sym
      else
        (module_or_name.nil? || module_or_name.to_s.empty?) ? 
        nil : module_or_name.to_sym
      end
    end

    def export(*modules)
      options = modules.last.is_a?(Hash) ? modules.pop : {}
      options = {
        :except_descendants => false
      }.update(options || {})
      sources = []
      unless options[:except_descendants]
        ObjectSpace.each_object(Class) do |klass|
          sources << klass if modules.any?{|mod| klass <= mod}
        end
      else
        sources = modules
      end
      result = {}
      sources.each do |source|
        if source.respond_to?(:prestruct)
          result[source.name] = source.prestruct.to_hash
        end
      end
      result
    end

    def build(source)
      result = {}
      source.each do |key, value|
        result[key] = Prestruct::ModuleDescription.build(key, value)
      end
      result
    end
  end
end
