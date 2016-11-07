require 'test_helper'
require 'yaml'
require 'configuration'

class ConfigurationTest < Minitest::Test
	class ParseError < StandardError; end

	def setup
		@configuration = Configuration.new('configtest.yml')
	end

	def fake_file
		file = '
repositories:
  - theforeman/foreman
  - theforeman/smart-proxy
  - theforeman/hammer-cli
  - theforeman/hammer-cli-foreman
users:
  - ares
  - tstrachota
  - inecas
line_size: 120
max_pr_digits: 4
log_level: 1'
		YAML.load(file)
	end

	def test_load_file	
		YAML.stub(:load_file, fake_file) do
			result = Configuration.new("filepath")
			assert_equal ['ares','tstrachota', 'inecas'], result.config["users"]
			assert_equal 120, result.config["line_size"]
			assert_equal 1, result.config['log_level']
		end
	end

	def test_respond_to_missing?
		assert @configuration.respond_to?(:users)
		refute @configuration.respond_to?(:notExistingMethod)
		assert_raises NameError do 
			@configuration.method :notExistingMethod
		end
		assert @configuration.method :users
	end

	def test_method_missing
		assert_raises NoMethodError do 
			@configuration.notExistingKey
		end
		assert_equal ['ares','tstrachota', 'inecas'], @configuration.users
		assert_equal 120, @configuration.line_size
		assert_equal 1, @configuration.log_level
	end

	def test_initialize
		assert_equal ['ares','tstrachota', 'inecas'], @configuration.config["users"]
	end

	def test_raise_parseError
		assert_raises Configuration::ParseError do
  			Configuration.new("")
		end
	end
end