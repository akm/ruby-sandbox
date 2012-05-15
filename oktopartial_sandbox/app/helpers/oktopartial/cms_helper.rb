module Oktopartial::CmsHelper
  DISPLAY_STATUS_STRS = {
    :NG => '--',
    :DI => 'DI',
    :OK => 'OK',
    :NA => 'NA',
  }

  def to_display_status(status)
    DISPLAY_STATUS_STRS[status] || status.to_s
  end

end
