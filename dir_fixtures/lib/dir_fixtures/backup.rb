require 'tmpdir'
module DirFixtures
  class Backup
    class << self
      def instances
        @instances ||= {}
      end

      def transaction(target, options = nil, &block)
        options = {
          :cache => nil
        }.update(options || {})
        instance = instances[target] if options[:cache] 
        unless instance
          instance = self.new(target, options.delete(:dir) || Dir.tmpdir, options)
          instances[target] = instance
        end
        instance.transaction(&block)
      end
    end

    attr_accessor :dest_dir
    attr_accessor :src_path, :dest_path
    attr_accessor :options

    def initialize(src_dir, dest_dir, options = nil)
      options = {
      }.update(options || {})
      @cache = options[:cache]
      @src_path = src_dir 
      @dest_dir = dest_dir
      @dest_path = File.join(dest_dir, File.basename(src_dir))
    end

    def transaction
      setup
      yield if block_given?
    ensure
      rollback
    end

    def setup
      raise BackupError, "directory doesn't exist: #{dest_dir}" unless File.exist?(dest_dir)
      if File.exist?(dest_path)
        return if @cache
        raise BackupError, "directory already exists: #{dest_dir}" 
      end
      FileUtils.cp_r(src_path, dest_path)
    end

    def rollback
      FileUtils.rm_rf(src_path)
      if @cache
        FileUtils.cp_r(dest_path, src_path)
      else
        FileUtils.mv(dest_path, src_path)
      end
    end

  end
end
