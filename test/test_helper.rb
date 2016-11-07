require 'simplecov'
require 'minitest/autorun'
SimpleCov.start do
	 add_filter "/lib/"
SimpleCov.minimum_coverage 95
end

