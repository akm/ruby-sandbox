require 'prestruct'

module Prestruct
  class Description
    attr_reader :name
    def initialize(name, attrs = nil)
      @name = name.to_s
      update(attrs) if attrs
    end

    def attributes
      @attributes ||= {}
    end

    def update(attrs)
      attrs.each do |key, value|
        attributes[key.to_sym] = value
      end
    end

    def [](attr_name)
      return nil unless attr_name
      return nil if attr_name.to_s.empty?
      attributes[attr_name.to_sym]
    end

    def to_hash
      result = {}
      attributes.each do |key, value|
        result[key.to_s] = value
      end
      result
    end

  end
end
