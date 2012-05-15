# -*- coding: utf-8 -*-
module Oktopartial
  autoload :MimeType, 'oktopartial/mime_type'

  mattr_accessor :archive_dir
  self.archive_dir = File.join(RAILS_ROOT, 'tmp/oktopartial/archives')

  mattr_accessor :staging_dir
  self.staging_dir = File.join(RAILS_ROOT, 'tmp/oktopartial/stagings')


  # oktopartialのCSSをロードするためのcontent_forにしていするキー。
  # デフォルトでは:css。
  # app/views/layouts/application.html.erbに yield(:css)などの指定がなければ
  # 追加しておいてください。
  mattr_accessor :key_of_content_for_css
  self.key_of_content_for_css = :css
end
