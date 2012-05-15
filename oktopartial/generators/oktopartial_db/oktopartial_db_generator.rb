class OktopartialDbGenerator < Rails::Generator::Base
  
  def initialize(runtime_args, runtime_options = {})
    super(runtime_args, runtime_options)
    @singular_name = 'oktopartial_db'
  end

  def manifest
    record do |m|
      m.migration_template("create_oktopartial_tables.rb", 'db/migrate',
        :migration_file_name => "create_oktopartial_tables.rb")
    end
  end
end
