class Endoscope::DependenciesController < ActionController::Base

  layout 'endoscope/layouts/application'

  def index
    @dependencies = Endoscope::Dependency.instances
  end

  def show
    @dependency = Endoscope::Dependency.instances[params[:id].to_i]
  end
  
end
