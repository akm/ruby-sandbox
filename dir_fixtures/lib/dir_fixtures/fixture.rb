module DirFixtures
  class Fixture
    class << self
      def setup(dest_dir, fixture_path, options = nil)
        options = {
          :protected_paths => nil
        }.update(options || {})
        (options[:protected_paths] || []).each do |protected_path|
          violated_dirs = Dir.glob(File.join(fixture_path, protected_path, '**/*'))
          unless violated_dirs.empty?
            raise ProtectViolationError, "#{protected_path} is protected, but fixture '#{fixture_path} includes #{violated_dirs.inspect}'"
          end
        end
        src_list = (Dir.entries(fixture_path) - %w(. ..)).map{|path| File.join(fixture_path, path)}
        FileUtils.cp_r(src_list, dest_dir)
      end

    end
  end
end
