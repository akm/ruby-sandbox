class DependenciesController < ApplicationController
  def index
    @dependencies = Tracer::Dependency.instances
  end

  def show
    @dependency = Tracer::Dependency.instances[params[:id].to_i]
  end
  
end
