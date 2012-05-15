class Oktopartial::LayoutsController < ApplicationController
  unloadable

  CONTENT_PLACE_HOLDER = '<div class="oktopartial_content"></div>'

  def method_missing(action_name)
    result = render_to_string(:text => CONTENT_PLACE_HOLDER, 
      :layout => action_name)
    result.gsub!(/\A.*<body(\s[^>]+?)?>/m, '<!-- rendered at server side -->')
    result.gsub!(/<\/body>.*\Z/m, '')
    render :text => result
  end

end
