# -*- coding: utf-8 -*-

def ec2_client
  require 'rubygems'
  require 'right_aws'
  access_key = `cat ~/.ec2/access_key`.strip
  secret_access_key = `cat ~/.ec2/secret_access_key`.strip
  RightAws::Ec2.new(access_key, secret_access_key,
    :region => "us-west-1")
end


namespace :ec2 do

  namespace :list do
    desc "list of all instances"
    task :default do
      require 'yaml'
      puts YAML.dump(ec2_client.describe_instances)
    end

    %w(pending running shuting-down terminated).each do |st|
      desc "list of #{st} instances"
      task st do
        instances = ec2_client.describe_instances.select{|i| i[:aws_state] == st}
        require 'yaml'
        puts YAML.dump(instances)
      end
    end
  end

end


if (ENV['TARGET'].nil? || ENV['TARGET'].empty?)
  # ENV['TARGET'] でデプロイ先のホストを指定されていない場合
  
  # 起動するインスタンスの元となるAMI
  ami_id = "ami-cf89d88a"

  namespace :ec2 do
    desc "launch an instance from #{ami_id}"
    task :launch do
      ec2_client.launch_instances(ami_id,
        :min_count => 1,
        :max_count => 1,
        :group_ids => ['default', 'ruby-dev'],
        :key_name => 'west-dev01'
        )
    end
  end
  
else

  # ENV['TARGET'] でデプロイ先のホストを指定されている場合
  target_server_id = ENV['TARGET'].strip

  target_server = ec2_client.describe_instances.detect{|i| i[:aws_instance_id] == target_server_id}[:dns_name] # or [:ip_address]
  puts "instance id      : #{target_server_id}"
  puts "instance hostname: #{target_server}"

  target_key = ENV['TARGET_KEY'] || "~/.ec2/west-dev01.pem"
  target_key = File.expand_path(target_key)
  unless File.exist?(target_key)
    raise "WARNING! You must set TARGET_KEY=/path/to/target/private/key"
  end

  set :application, "rbc_20100522"
  default_run_options[:pty] = true

  set :user, "ubuntu"
  ssh_options[:user] = 'ubuntu'
  ssh_options[:forward_agent] = true
  ssh_options[:keys] = target_key
  set :use_sudo, true

  set :scm, :git
  set :branch,  "master"
  set :repository,  "git://github.com/akm/20100522-deploy_example.git"

  set :deploy_via, :remote_cache
  set :copy_cache, true

  # for git submodules
  # see also http://github.com/guides/deploying-with-capistrano
  set :git_enable_submodules, 1
  set :keep_releases, 3

  role :web, target_server                   # Your HTTP server, Apache/etc
  role :app, target_server                   # This may be the same as your `Web` server
  role :db,  target_server, :primary => true # This is where Rails migrations will run

  namespace :app do
    task :setup do
      run "#{sudo} mkdir -p #{shared_path}/config"
      run "#{sudo} mkdir -p #{shared_path}/db"
      run "#{sudo} touch #{shared_path}/db/production.sqlite3"
      config_db = "#{shared_path}/config/database.yml"
      put(<<-EOS, "~/database.yml", :via => :scp)
development:
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000
test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000
production:
  adapter: sqlite3
  database: db/production.sqlite3
  pool: 5
  timeout: 5000
EOS
      run "#{sudo} mv ~/database.yml #{config_db}"
      run "#{sudo} chown -R #{user}:#{user} #{deploy_to}"
    end

    task :symlinks do
      run "#{sudo} ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      run "#{sudo} ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
    end

    desc "install gems"
    task :gems do
      run "cd #{current_path} && #{sudo} gem install rails -v 2.3.5 --no-ri --no-rdoc && #{sudo} gem install mongrel sqlite3-ruby --no-ri --no-rdoc && #{sudo} /var/lib/gems/1.8/bin/rake gems:install"
    end
  end
  after "deploy:setup", "app:setup"
  after "deploy:update_code", "app:symlinks"

  namespace :ec2 do
    desc "terminate the instance #{target_server_id}"
    task :terminate do
      ec2_client.terminate_instances([target_server_id])
    end
  end

  set :mongrel_pid_file, "tmp/pids/mongrel.80.pid"
  set :mongrel_bin, "/var/lib/gems/1.8/bin/mongrel_rails"
  namespace :mongrel do
    desc "start mongrel simply"
    task :start do
      run "cd #{current_path} && #{sudo} -i #{mongrel_bin} start -p 80 -d -e production -P #{mongrel_pid_file} -c #{current_path}"
    end

    desc "stop mongrel simply"
    task :stop do
      run "cd #{current_path} && #{sudo} -i #{mongrel_bin} stop -P #{mongrel_pid_file} -c #{current_path}"
    end

    desc "restart mongrel simply"
    task :restart do
      run "cd #{current_path} && #{sudo} -i #{mongrel_bin} restart -P #{mongrel_pid_file} -c #{current_path}"
    end
  end

  namespace :deploy do
    task(:start) { mongrel.start }
    task(:stop) { mongrel.stop }
    task(:restart) { mongrel.restart }
  end

end
