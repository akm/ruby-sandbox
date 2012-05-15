require 'prestruct'

module Prestruct
  class ModuleDescription < Description
    def method_descriptions
      @method_descriptions ||= {}
    end

    def find_or_new_method(method_name)
      name = method_name.to_sym
      unless result = method_descriptions[name]
        method_descriptions[name] = result = MethodDescription.new(name)
      end
      result
    end

    def to_hash
      result = super
      unless method_descriptions.empty?
        result["methods"] = methods = {}
        method_descriptions.each do |key, value|
          methods[key.to_s] = value.to_hash
        end
      end
      result
    end

    def self.build(name, attrs)
      methods = attrs.delete('methods')
      result = self.new(name, attrs)
      if methods
        methods.each do |attr, value|
          result.method_descriptions[attr.to_sym] = MethodDescription.new(attr, value)
        end
      end
      result
    end

  end
end
