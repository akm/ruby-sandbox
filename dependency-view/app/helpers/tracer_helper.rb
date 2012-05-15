module TracerHelper
  def render_descendants(root = nil, depth = 0, &block)
    root ||= Object
    yield(root, depth)
    render_children(root, depth, &block)
  end
  
  def render_children(klass, depth, &block)
    children = @class_inheritances[klass]
    return unless children
    children = children.sort_by{|m| m.name.blank? ? '' : m.name}
    children_depth = depth + 1
    children.each do |child|
      yield(child, children_depth)
      render_children(child, children_depth, &block)
    end
  end
  
  def module_name(m)
    h(m.name.blank? ? m.inspect : m.name)
  end
  
  def link_to_module(m)
    link_to(module_name(m), :controller => 'modules', :action => 'show', :id => m.object_id)
  end
 
  def each_direct_included_modules(m, nesting = 0, &block)
    all_included_modules = m.included_modules
    all_included_modules -= m.superclass.included_modules if (m != Object) && m.is_a?(Class)
    all_included_modules.dup.each do |sub_module|
      all_included_modules -= sub_module.included_modules
    end
    if block_given?
      if nesting
        nesting = nesting.to_i
        sub_nesting = nesting + 1
        all_included_modules.each do |sub_module|
          yield(sub_module, nesting)
          each_direct_included_modules(sub_module, sub_nesting, &block)
        end
      else
        all_included_modules.each(&block)
      end
    else
      return all_included_modules.map do |m|
        link_to_module(m)
      end.join(' ')
    end
  end

end
