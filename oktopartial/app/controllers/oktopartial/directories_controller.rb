class Oktopartial::DirectoriesController < ApplicationController
  unloadable

  def new
  end

  def create
    dir_name = params[:directory_name]
    validate_directory_name(dir_name)
    if flash[:error].nil?
      FileUtils.mkdir_p(File.join(RAILS_ROOT, 'public', dir_name))
    end
    redirect_to :controller => 'contents', :action => :index
  end

  def destroy
    dir_name = params[:directory_name]
    validate_directory_name(dir_name)
    if flash[:error].nil?
      path = File.join(RAILS_ROOT, 'public', dir_name)
      logger.debug(path)
      FileUtils.rm_rf(path, :verbose => true)
    end
    Oktopartial::Content.update_all
    redirect_to :controller => 'contents', :action => :index
  end

  private

  INVALID_CHARS = ":;?,"
  INVALID_PATTERN = /#{Regexp.escape(INVALID_CHARS)}|(?:^|\/)\.\.?(?:\/|$)/

  def validate_directory_name(dir_name)
    flash[:error] = nil
    if dir_name.blank?
      flash[:error] = "No directory name specified."
    elsif dir_name =~ INVALID_PATTERN
      flash[:error] = "Invalid directory name: #{dir_name}"
    end
  end

end
