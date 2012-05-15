# -*- coding: utf-8 -*-
class Endoscope::ModulesController < ActionController::Base

  layout 'endoscope/layouts/application'

  def index
    block = nil
    if name = params[:name]
      # ^と$以外の正規表現はエスケープして使えないようにします。
      pattern = ''
      pattern << '^' if name =~ /^\^/
      pattern << Regexp.escape(name.gsub(/^\^|\$$/, ''))
      pattern << '$' if name =~ /\$$/
      pattern = Regexp.new(pattern, !!params[:ignore_case])
      logger.warn(pattern.inspect)
      block = Proc.new{|m| m.name ? m.name =~ pattern : false}
    end
    @class_inheritances = {Object => []}
    all_classes = Endoscope.all_modules(Class, &block)

    all_classes.each do |m|
      @class_inheritances[m.superclass] ||= []
      @class_inheritances[m.superclass] << m
    end
    
    @modules = Endoscope.all_modules_except_class(&block).
      sort_by{ |m| m.name.blank? ? '' : m.name}
  end

  def show
    @module = /\d+/o =~ params[:id] ?
      Endoscope.detect(params[:id].to_i) :
      Endoscope.find_by_name(params[:id])
    
    @ancestors = @module.is_a?(Class) ? klass_ancestors(@module) : []
    
    descendants = Endoscope.all_modules(Class) do |klass|
      klass < @module
    end
    @class_inheritances = {@module => []}
    descendants.each do |m|
      @class_inheritances[m.superclass] ||= []
      @class_inheritances[m.superclass] << m
    end
    
    @including_modules = []
    @nestings = []
    regexp = Regexp.new("^#{Regexp.escape(@module.name)}\:\:")
    Endoscope.each_object(Module) do |m|
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
