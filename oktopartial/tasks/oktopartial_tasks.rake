require 'fileutils'

namespace :oktopartial do

  ASSETS = {
    :js => 'javascripts',
    :css => 'stylesheets'
  }

  desc "Instal assets(js and css)"
  task :setup => ASSETS.keys
  
  ASSETS.each do |task_name, path|
    desc "Copy #{task_name} files to RAILS_ROOT/public/#{path}"
    task task_name => :environment do
      Dir.glob(File.join(File.dirname(__FILE__), "../assets/#{path}/*.*")) do |src|
        basename = File.basename(src)
        dest = File.join(RAILS_ROOT, "public/#{path}", basename)
        FileUtils.cp_r(src, dest, :verbose => true)
      end
    end
  end

  desc "Show all controller's action paths"
  task :routes => :environment do
    Oktopartial::Content.actions_from_routes_and_methods do |path, controller_name, action_name, route|
      puts (route.conditions[:method] || '').to_s.upcase.ljust(7) << path
    end
  end

  desc "Show all view's paths"
  task :views => :environment do
    puts Oktopartial::Content.views_from_app_views
  end

  desc "Show all public static files"
  task :html => :environment do
    puts Oktopartial::Content.statics_from_public
  end

  DISPLAY_STATUS_STRS = {
    :NG => '--',
    :DI => 'DI',
    :OK => 'OK',
    :NA => 'NA',
  }
  def to_display_status(status)
    DISPLAY_STATUS_STRS[status] || status.to_s
  end

  desc "Show all routes, views and static files"
  task :paths => :environment do
    paths = Oktopartial::Content.routes_and_files
    path_width = paths.collect{|path| path.name.length}.max
    puts "method  #{'Path'.ljust(path_width)} HTML Action View"
    paths.each do |path|
      action = to_display_status(path.status_action)
      view = to_display_status(path.status_view)
      html = to_display_status(path.status_static)
      puts "#{(path.method || '').to_s.upcase.ljust(7)} #{path.name.ljust(path_width)}  #{html}    #{action}    #{view}"
    end
    puts "==== legend ===="
    puts "  -- : not exist"
    puts "  OK : available"
    puts "  NA : Not Available"
    puts "  DI : Depends on Implementation or config/routes.rb"
    puts "==== Note ===="
    puts "  actual view file extension is not .html but .html.erb or .rhtml"
  end

end
