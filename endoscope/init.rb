if Module.constants.include?('Endoscope')

  old_versions = %w(1.x.x 1.2.x 2.0.x 2.1.x 2.2.x)
  if RAILS_GEM_VERSION =~ Regexp.union(*old_versions.map{|v| Regexp.new(v.gsub(/\./, '\\.').gsub(/x/, '\\d?'))})
    require 'endoscope'

    ActiveSupport::Dependencies.load_paths << File.join(directory, 'app', 'controllers')
    ActiveSupport::Dependencies.load_paths << File.join(directory, 'app', 'helpers')

    $LOAD_PATH << File.join(directory, 'app', 'controllers')
    $LOAD_PATH << File.join(directory, 'app', 'helpers')

    config.controller_paths << File.join(directory, 'app', 'controllers')

    plugin_views_path = File.join(directory, 'app', 'views')

    controllers = %w(dependencies features modules).map{|c| "endoscope/#{c}_controller"}
    controllers.each do |controller|
      require controller
    end

    ActionController::Base.append_view_path plugin_views_path
  end

end
