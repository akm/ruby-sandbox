# -*- coding: utf-8 -*-
class NestableLogger
  LEVELS = %w[debug info warn error fatal unknown].freeze

  # Loggerの定数と同じ
  DEBUG = 0
  INFO  = 1
  WARN  = 2
  ERROR = 3
  FATAL = 4
  UNKNOWN = 5

  attr_reader :options
  def initialize(impl, options = {})
    @impl = impl
    @options = options || {}
    @msg_stack = []
    @last_index = 0
  end

  def add_method(severity, object, method_name = nil, msg = nil, &block)
    method_name ||= caller[1].scan(/\`(.+)\'/).flatten.first
    name = object.is_a?(Module) ? "#{object.name}.#{method_name}" : "#{object.class.name}##{method_name}"
    name << ' ' << msg if msg
    stack(name) do |m|
      add(severity, m, &block)
    end
  end

  def add_index(severity, msg = nil, &block)
    index = (@last_index || 0).succ
    @last_index = index
    msg = msg ? "#{index.to_s} #{msg}" : index.to_s
    stack(msg) do |m|
      add(severity, m, &block)
    end
  end

  def add(severity, msg)
    if block_given?
      @impl.send(LEVELS[severity.to_i], "#{msg} S")
      begin
        last_index_backup = @last_index
        @last_index = 0
        begin
          result = yield
        ensure
          @last_index = last_index_backup
        end
        @impl.send(LEVELS[severity.to_i], "#{msg} E")
        return result
      rescue Exception => err
        # 実装中にspecしたときにメッセージがややこしくなるのでSpec関係のエラーは無視
        unless err.class.name =~ /^Spec::Mocks::/
          @impl.send(LEVELS[severity.to_i],
            "#{msg} ERROR\n  [#{err.class.name}] #{err.to_s}\n  " << err.backtrace.join("\n  "))
        end
        raise
      end
    else
      @impl.send(LEVELS[severity.to_i], msg)
    end
  end

  def stack(msg)
    @msg_stack << (msg || '')
    begin
      yield(@msg_stack.join('.'))
    ensure
      @msg_stack.pop
    end
  end

  (LEVELS - %w[unknown]).each do |level|
    module_eval(<<-"EOS", __FILE__, __LINE__ + 1)
      def #{level}_method(*args, &block)
        add_method(#{level.upcase}, *args, &block)
      end

      def #{level}_index(*args, &block)
        add_index(#{level.upcase}, *args, &block)
      end

      def #{level}(*args, &block)
        add(#{level.upcase}, *args, &block)
      end
    EOS
  end

end
