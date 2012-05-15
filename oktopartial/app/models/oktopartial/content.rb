# -*- coding: utf-8 -*-
require 'fileutils'

class Oktopartial::Content < ActiveRecord::Base
  set_table_name "oktopartial_contents"

  BASE_ACTION_NAMES = %w(index show new create edit update destroy)

  named_scope :under, lambda {|dir_path|
    result = {:order => "path asc"}
    dir_path = (dir_path =~ /\/$/) ? dir_path : "#{dir_path}/"
    unless dir_path.blank?
      result[:conditions] = ["path like ?", "#{dir_path}%"]
    end
    result
  }

  def status_static
    !!static_cd ? :OK : :NG
  end

  def status_action
    action_cd.nil? ? :NG : !!static_cd ? :NA : :DI
  end
  
  def status_view
    view_cd.nil? ? :NG : view_cd.to_sym
  end
  
  class << self
    def directories_from(root_path = File.join(RAILS_ROOT, 'public'))
      root_path_regexp = /^#{Regexp.escape(root_path)}/
      logger.debug("root_path: " << root_path)
      dirs = Dir.glob(File.join(root_path, '**/*')).
        select{|dir| File.directory?(dir)}.
        map{|dir| dir.sub(root_path_regexp, '')}.uniq.sort
      dirs.unshift('/')
      dirs
    end

    def update_all
      transaction do
        delete_all
        contents = routes_and_files
        contents.each(&:save!)
      end
    end

    def actions_from_routes_and_methods
      ignored_controller_methods = Object.public_instance_methods + ActionController::Base.public_instance_methods
      base_path = File.join(RAILS_ROOT, 'app/controllers')
      actual_actions = []
      Dir.glob(File.join(base_path, '**/*_controller.rb')) do |controller_path|
        require controller_path
        basename = controller_path.sub(/#{Regexp.escape(base_path)}\//, '').sub(/\.rb$/, '')
        klass = basename.classify.constantize
        controller_name = klass.controller_path
        next if controller_name == 'ApplicationController'
        action_names = klass.public_instance_methods.sort - ignored_controller_methods
        # BASE_ACTION_NAMESに関しては先頭にして、それ以外はソート順で。
        action_names = (BASE_ACTION_NAMES - (BASE_ACTION_NAMES - action_names)) + (action_names - BASE_ACTION_NAMES)
        action_names.each do |action_name|
          actual_actions << {:controller => controller_name, :action => action_name}
        end
      end
      all_routes = ActionController::Routing::Routes.routes
      controller_route_hash = all_routes.inject({}) do |dest, route|
        controller_name = route.defaults[:controller]
        unless controller_name.blank?
          dest[controller_name] ||= []
          dest[controller_name] << route
        end
        dest
      end
      paths = []
      # controller名が指定されているルート
      actual_actions.each do |record|
        controller_name = record[:controller]
        action_name = record[:action]
        next unless controller_routes = controller_route_hash[controller_name]
        controller_routes.each do |r|
          route_action = r.defaults[:action]
          next unless route_action.blank? || (route_action == action_name)
          segs = r.segments.inject("") { |str,s| str << s.to_s }
          path = segs.gsub(/:controller/, controller_name).gsub(/:action/, action_name).gsub(/:format/, 'html')
          yield(path, controller_name, action_name, r) if block_given?
          paths << path
          record[:added] = true
        end
      end
      # controller名が指定されていないルート
      no_controler_routes = all_routes - controller_route_hash.values.flatten
      uniq_no_controler_routes = []
      #  map.connect ':controller/:action/:id'
      #  map.connect ':controller/:action/:id.:format'
      # というような重複しているように見えるルートをまとめています。
      no_controler_routes.each do |r1|
        r1_path = r1.segments.inject("") { |str,s| str << s.to_s }.gsub(/:format/, 'html').sub(/\/$/, '(.html)?')
        duplicated = uniq_no_controler_routes.any? do |r2|
          r2_path = r2.segments.inject("") { |str,s| str << s.to_s }.gsub(/:format/, 'html').sub(/\/$/, '(.html)?')
          r1_path == r2_path
        end
        if uniq_no_controler_routes.empty? || !duplicated
          uniq_no_controler_routes << r1
        end
      end
      actual_actions.each do |record|
        next if record[:added]
        controller_name = record[:controller]
        action_name = record[:action]
        uniq_no_controler_routes.each do |r|
          segs = r.segments.inject("") { |str,s| str << s.to_s }
          path = segs.gsub(/:controller/, controller_name).gsub(/:action/, action_name).gsub(/:format/, 'html').sub(/\/$/, '(.html)?')
          yield(path, controller_name, action_name, r) if block_given?
          paths << path
        end
      end
      return paths
    end

    def views_from_app_views
      glob_files(File.join(RAILS_ROOT, 'app/views'), '**/*.{rhtml,erb}')
    end

    def statics_from_public
      glob_files(File.join(RAILS_ROOT, 'public'))
    end

    private
    
    def glob_files(base_path, pattern = '**/*')
      paths = []
      FileUtils.cd(base_path) do
        Dir.glob(pattern) do |path|
          next if File.directory?(path)
          path = "/#{path}" if path !~ /^\//
          paths << path
        end
      end
      paths
    end

    public

    def routes_and_files
      paths = []
      action_paths = {}
      # HTMLの方がアクションよりも優先順位が高いです。
      self.statics_from_public.each do |path|
        obj = self.new(:method_name => 'GET', :path => path)
        obj.static_cd = 'OK'
        paths << obj
        action_paths[obj.path] = obj 
      end
      # アクション
      self.actions_from_routes_and_methods do |path, controller_name, action_name, route|
        obj = self.new(:method_name => route.conditions[:method].to_s.upcase, :path => path.sub(/\(\.html\)\?/, '.html'))
        process_action_path(paths, action_paths, obj)
        if obj.path =~ /\/:id/
          obj = self.new(:method_name => obj.method_name, :path => obj.path.sub(/\/:id/, ''))
          process_action_path(paths, action_paths, obj)
        end
        if (obj.method_name.nil? || obj.method_name == 'GET')
          view_path = "/#{controller_name}/#{action_name}.html"
          unless obj.path == view_path
            action_paths[view_path] ||= obj # keyは正しくないけど、ビューでそれを判断します。
          end
        end
      end
      # ビュー
      self.views_from_app_views.map{|v| v.sub(/\.rhtml$|(?:\.html)?\.erb$/, '.html')}.each do |path|
        view_stat = nil
        if obj = action_paths[path]
          if obj.path == path
            # パスも同じ、コントローラがある場合
            obj.view_cd = !!obj.static_cd ? 'NA' : !!obj.action_cd ? 'DI' : 'OK'
          else
            # パスは違うけど、コントローラがある場合
            view_stat = 'DI'
            obj = nil
          end
        end
        unless obj
          obj = (action_paths[path] = self.new(:method_name => 'GET', :path => path))
          basename = File.basename(obj.path)
          obj.view_cd = view_stat || (basename =~ /^_/ ? 'DI' : 'OK')
          paths << obj
        end
      end
      # パス名でソート
      paths.sort_by(&:path)
    end

    private
    
    def process_action_path(paths, action_paths, obj)
      html = action_paths[obj.path] # HTMLのmethod_nameは必ず:get
      if html && (obj.method_name == 'GET')
        obj = html
      else
        action_paths[obj.path] ||= obj
        paths << obj
      end
      obj.action_cd = 'OK'
    end

  end
end
