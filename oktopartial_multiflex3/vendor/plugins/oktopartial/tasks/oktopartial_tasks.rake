require 'fileutils'

namespace :oktopartial do

  desc "Instal js"
  task :setup => :'oktopartial:js:install'
  
  namespace :js do
    desc "Copy js files to RAILS_ROOT/public/javascripts"
    task :install => :environment do
      Dir.glob(File.join(File.dirname(__FILE__), "../assets/javascripts/*.*")) do |src|
        basename = File.basename(src)
        dest = File.join(RAILS_ROOT, 'public/javascripts', basename)
        FileUtils.cp_r(src, dest)
      end
    end
  end

end
