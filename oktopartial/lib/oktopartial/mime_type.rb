# -*- coding: utf-8 -*-
require 'oktopartial'
module Oktopartial
  module MimeType
    class << self
      # File.extnameで得られる拡張子('.png'や'.html')で検索します。
      # ドットのない拡張子('png'や'html')でもOK。
      def by_extname(extname)
        extname = extname.to_s.downcase.sub(/^\./, '')
        extname_to_mime_type[extname]
      end

      def discrete_type_by_ext(extname)
        discrete_type_by_mime_type(by_extname(extname))
      end

      def discrete_type_by_mime_type(mime_type)
        mime_type.split(/\//, 2).first.to_sym
      end

      private
      
      def extname_to_mime_type
        unless @extname_to_mime_type
          @extname_to_mime_type = {}
          IO.foreach(File.join(File.dirname(__FILE__), 'mime_type.txt')) do |line|
            next if line =~ /^\s*\#/
            ext, name = *line.split(/:/, 2)
            @extname_to_mime_type[ext.strip.downcase] = name.strip
          end
        end
        @extname_to_mime_type
      end
    end
    
  end
end
