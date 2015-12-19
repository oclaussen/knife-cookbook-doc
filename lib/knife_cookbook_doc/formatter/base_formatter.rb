module KnifeCookbookDoc
  class BaseFormatter
    attr_reader :model
    attr_reader :config

    def initialize(model, config)
      @model = model
      @config = config
    end

    # Make subclasses magically aware of all configured formatters.
    # Also, create a fresh formatter instance for every call to `format`.
    # This assumes that all formatters are stateless.

    def method_missing(name, *args, &_blk)
      find_formatter(name).new(args[0] || @model, @config).format
    end

    def respond_to?(name, *_args, &_blk)
      !find_formatter(name).nil?
    end

    private

    def find_formatter(name)
      return nil unless /format_\w+/ =~ name.to_s
      type = /format_(\w+)/.match(name.to_s)[1]
      @config["#{type}_formatter".to_sym]
    end
  end
end
