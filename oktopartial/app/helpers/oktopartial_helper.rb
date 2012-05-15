module OktopartialHelper
  
  def flash_messages
    return nil if flash[:error].blank?
    result = '<div class="oktopartial_errors">'
    messages = flash[:error].is_a?(Array) ? flash[:error] : 
      flash[:error].to_s.split(/$/)
    messages.each do |message|
      result << '<p>'
      result << h(message)
      result << '</p>'
    end
    result << '</div>'
    result
  end


end
