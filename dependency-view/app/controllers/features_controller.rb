class FeaturesController < ApplicationController
  def index
    @features = Tracer.features.keys
  end

  def show
    feature_name = params[:id]
    feature_name << ('.' << params[:format]) if params[:format]
    @feature = Tracer.features[feature_name]
    render :action => "show.html.erb"
  end

end
