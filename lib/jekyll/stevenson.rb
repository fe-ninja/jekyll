module Jekyll
  class Stevenson
    attr_accessor :log_level

    DEBUG  = 0
    INFO   = 1
    WARN   = 2
    ERROR  = 3

    SYMBOL_MAP = {
      :debug => DEBUG,
      :info  => INFO,
      :warn  => WARN,
      :error => ERROR
    }

    # Public: Create a new instance of Stevenson, Jekyll's logger
    #
    # level - (optional, integer) the log level
    #
    # Returns nothing
    def initialize(level = INFO)
      set_log_level(level)
    end

    def set_log_level(level)
      if level.is_a?(Fixnum)
        @log_level = level
      elsif (level.is_a?(Symbol) || level.is_a?(String)) && SYMBOL_MAP.has_key?(level.to_sym)
        @log_level = SYMBOL_MAP[level.to_sym]
      else
        abort_with("Log level '#{level}' is not a valid log level.")
      end
    end

    # Public: Print a jekyll debug message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def debug(topic, message = nil)
      $stdout.puts(message(topic, message)) if log_level <= DEBUG
    end

    # Public: Print a jekyll message to stdout
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def info(topic, message = nil)
      $stdout.puts(message(topic, message)) if log_level <= INFO
    end

    # Public: Print a jekyll message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def warn(topic, message = nil)
      $stderr.puts(message(topic, message).yellow) if log_level <= WARN
    end

    # Public: Print a jekyll error message to stderr
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns nothing
    def error(topic, message = nil)
      $stderr.puts(message(topic, message).red) if log_level <= ERROR
    end

    # Public: Print a Jekyll error message to stderr and immediately abort the process
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail (can be omitted)
    #
    # Returns nothing
    def abort_with(topic, message = nil)
      error(topic, message)
      abort
    end

    # Public: Build a Jekyll topic method
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # message - the message detail
    #
    # Returns the formatted message
    def message(topic, message)
      msg = formatted_topic(topic) + message.to_s.gsub(/\s+/, ' ')
      messages << msg
      msg
    end

    def messages
      @messages ||= []
    end

    # Public: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    #
    # Returns the formatted topic statement
    def formatted_topic(topic)
      "#{topic} ".rjust(20)
    end
  end
end
