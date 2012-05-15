# -*- coding: utf-8 -*-
require 'fileutils'
require 'zip/zipfilesystem'

class Oktopartial::Publication < ActiveRecord::Base
  set_table_name 'oktopartial_publications'

  attr_accessor :uploaded_file
  attr_accessor :dest_dir

  validates_presence_of :uploaded_file, :on => :create
  validates_presence_of :source_path
  validates_presence_of :dirname
  validates_presence_of :published_at

  validates_uniqueness_of :source_path, :dirname

  # (0:公開準備中, 1:公開準備エラー, 2:公開待ち, 3:公開中, 4:公開済み, 5:公開エラー)
  STATUS_CDS = [
    {:cd => '0', :key => :preparing        , :name => '公開準備中'    },
    {:cd => '1', :key => :preparation_error, :name => '公開準備エラー'},
    {:cd => '2', :key => :staging          , :name => '公開待ち'      },
    {:cd => '3', :key => :publishing       , :name => '公開中'        },
    {:cd => '4', :key => :published        , :name => '公開済み'      },
    {:cd => '5', :key => :publishing_error , :name => '公開エラー'    },
  ]
  STATUS_CD_TO_KEY = STATUS_CDS.inject({}){|d, entry| d[entry[:cd]] = entry[:key]; d}
  STATUS_KEY_TO_CD = STATUS_CDS.inject({}){|d, entry| d[entry[:key]] = entry[:cd]; d}
  STATUS_CD_TO_NAME = STATUS_CDS.inject({}){|d, entry| d[entry[:cd]] = entry[:name]; d}
  STATUS_CD_OPTIONS = STATUS_CDS.map{|entry| [entry[:name], entry[:cd]]}
  
  def status_key; STATUS_CD_TO_KEY[status_cd]; end
  def status_key=(value); self.status_cd = STATUS_KEY_TO_CD[value]; end
  def status_name; STATUS_CD_TO_NAME[status_cd]; end
  
  before_validation_on_create :save_uploaded_file

  def save_uploaded_file
    self.source_path = uploaded_file.original_path
    path = File.join(Oktopartial.archive_dir, self.source_path)
    FileUtils.mkdir_p(File.dirname(path))
    open(path, 'w') do |f|
      f.write(uploaded_file.read)
    end
    self.dirname = Time.now.strftime('%Y%m%d%H%M%S') << '-' << File.basename(self.source_path, '.*')
  end
  
  def prepare!
    begin
      case self.source_path
      when /\.zip$/i then
        extract_source_by_zip
      when /\.tar.gz$/i then
        extract_source_by_tar_gz
      else
        copy_source_file
      end
      self.status_key = :staging
    rescue Exception => error
      self.status_key = :preparation_error
      self.error_messages ||= ''
      self.error_messages << error.to_s << "\n  " << error.backtrace.join("\n  ")
    end
    self.save!
  end

  def archive?
    self.class.filetype(self.source_path) == :archive
  end

  def image?
    self.class.filetype(self.source_path) == :image
  end

  def text?
    self.class.filetype(self.source_path) == :text
  end

  def actual_source_path
    File.join(Oktopartial.archive_dir, self.source_path)
  end

  def actual_dir_path
    File.join(Oktopartial.staging_dir, self.dirname)
  end


  def entry_paths
    if archive? && [:preparing, :preparation_error, :staging].include?(self.status_key)
      result = []
      FileUtils.cd(File.join(Oktopartial.staging_dir, self.dirname)) do
        Dir.glob('**/*') do |path|
          result << path unless File.directory?(path)
        end
      end
      return result
    else
      []
    end
  end

  private
  
  # rubyzip を使っています。
  # http://rubyzip.sourceforge.net/
  def extract_source_by_zip
    Zip::ZipInputStream.open(actual_source_path) do |stream|
      while entry = stream.get_next_entry
        path = File.join(Oktopartial.staging_dir, self.dirname, entry.name)
        FileUtils.mkdir_p(File.dirname(path))
        # Zip::ZipEntry#file? は解凍したディレクトリでもtrueを返すし、
        # Zip::ZipEntry#directory? は解凍したディレクトリでもfalseを返します。
        unless /\/$/ =~ entry.name # entry.directory? # !entry.file?
          entry.extract(path)
        end
      end
    end
  end

  # コマンドを実行しています。
  def extract_source_by_tar_gz
    dest_path = copy_source_file
    begin
      FileUtils.cd(File.dirname(dest_path)) do
        msg = `tar zxf #{File.basename(dest_path)}`
        raise IOError, msg unless msg.blank?
      end
    ensure
      FileUtils.rm(dest_path)
    end
  end

  # 単純にファイルをコピーします
  def copy_source_file
    dest_path = File.join(Oktopartial.staging_dir, self.dirname, self.source_path)
    FileUtils.mkdir_p(File.dirname(dest_path))
    FileUtils.cp(actual_source_path, dest_path)
    dest_path
  end



  public
  class << self
    def prepare
      publication = nil
      self.transaction do
        if publication = self.find(:first, :lock => true, :order => 'published_at asc', 
          :conditions => [
            "status_cd = ? AND published_at < ?", STATUS_KEY_TO_CD[:preparing], Time.now])
          publication.prepare!
        end
      end
      publication
    end

    def filetype(filename)
      case filename
      when /\.(?:zip|tar\.gz)$/i          then :archive
      when /\.(?:jpg|jpeg|gif|png|bmp)$/i then :image
      when /\.(?:txt|css|js|html|html|xml|yaml|yml)$/i then :text
      when :unknown
      end
    end

  end


end
