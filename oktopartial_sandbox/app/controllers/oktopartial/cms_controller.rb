# -*- coding: utf-8 -*-
class Oktopartial::CmsController < ApplicationController
  
  def index
    @dir = params[:dir]
    @paths = Oktopartial::Path.routes_and_files
    pattern = @dir.nil? ? nil : (@dir == '/') ? /^\/[^\/]+$/ : /^#{Regexp.escape(@dir)}\/[^\/]+$/
    @dirs = @paths.map{|path| File.dirname(path.name)}.uniq.sort unless request.xhr?
    @paths = @paths.select{|path| path.name =~ pattern} if pattern
    render :partial => 'table' if request.xhr?
  end

  def new
  end

end
