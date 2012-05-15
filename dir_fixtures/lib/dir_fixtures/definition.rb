module DirFixtures
  class Definition
    attr_accessor :root_path
    attr_reader :options
    def initialize(root_path, options = nil)
      @root_path = root_path
      @options = {
        :backup_cache => nil
      }.update(options || {})
    end

    def target(value = nil)
      @target = value unless value.nil?
      @target
    end

    def protected_paths
      @protected_paths ||= []
    end

    def protect(*paths)
      dest = protected_paths
      paths.flatten.each{|path| dest << path}
      dest
    end

    def process(fixture_name, &block)
      Backup.transaction(target, :cache => options[:backup_cache]) do
        Fixture.setup(File.join(root_path, fixture_name), :protected_paths => protected_paths)
        yield
      end
    end

  end
end
