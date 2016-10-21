require 'yaml'

class Configuration
  class ParseError < StandardError; end

  attr_reader :config

  def initialize(path)
    @config = YAML.load_file(path)
  rescue => e
    raise ParseError, "Cannot open config file because of #{e.message}"
  end

  def method_missing(key, *args, &block)
    config_defines_method?(key) ? @config[key.to_s] : super
  end

  def respond_to_missing?(method_name, include_private = false)
    config_defines_method?(method_name) || super
  end

  private

  def config_defines_method?(key)
    @config.has_key?(key.to_s)
  end
end
