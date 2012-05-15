module DirFixtures

  autoload :Definition, 'dir_fixtures/definition'
  autoload :Backup, 'dir_fixtures/backup'
  autoload :Fixture, 'dir_fixtures/fixture'

  class << self
    def [](path)
      result = definitions[path]
      raise NoDefinitionError, "no definition found: #{path}" unless result
      result
    end

    def definitions
      @definitions ||= {}
    end

    def define(path, options = nil, &block)
      definition = Definition.new(path, options)
      definitions[path] = definition
      definition.instance_eval(&block) if block
      definition
    end

  end

  class NoDefinitionError < StandardError
  end

  class BackupError < StandardError
  end

  class ProtectViolationError < StandardError
  end


end
