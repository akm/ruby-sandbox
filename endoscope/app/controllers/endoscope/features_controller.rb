class Endoscope::FeaturesController < ActionController::Base

  layout 'endoscope/layouts/application'

  def index
    @features = Endoscope::Feature.instances.sort_by{|f| f.name}
  end

  def show
    @feature = Endoscope::Feature.instances[params[:id].to_i]
    raise ::ActionController::UnknownAction, "Feature[#{params[:id]}] not found" unless @feature
    render :action => "show.html.erb"
  end

end
