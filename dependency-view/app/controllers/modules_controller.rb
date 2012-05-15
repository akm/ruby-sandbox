class ModulesController < ApplicationController
  def index
    @class_inheritances = {Object => []}
    all_classes = ObjectSpace.all_modules(Class)
    all_classes.each do |m|
      @class_inheritances[m.superclass] ||= []
      @class_inheritances[m.superclass] << m
    end
    
    @modules = ObjectSpace.all_modules{|m| !m.is_a?(Class)}.sort_by do |m|
      m.name.blank? ? '' : m.name
    end
  end

  def show
    @module = /\d+/o =~ params[:id] ?
      ObjectSpace.detect(params[:id].to_i) :
      ObjectSpace.find_by_name(params[:id])
    
    @ancestors = @module.is_a?(Class) ? klass_ancestors(@module) : []
    
    descendants = []
    ObjectSpace.each_object(Class) do |klass|
      descendants << klass if klass < @module
    end
    @class_inheritances = {@module => []}
    descendants.each do |m|
      @class_inheritances[m.superclass] ||= []
      @class_inheritances[m.superclass] << m
    end
    
    @including_modules = []
    @nestings = []
    regexp = Regexp.new("^#{@module.name}\:\:")
    ObjectSpace.each_object(Module) do |m|
      @including_modules << m if m.included_modules.include?(@module) 
      @nestings << m if regexp =~ m.name
    end
    
  end
  
  def klass_ancestors(klass)
    result = []
    current = klass
    while current != Object
      current = current.superclass
      result << current
    end
    result.reverse
  end
  
end
