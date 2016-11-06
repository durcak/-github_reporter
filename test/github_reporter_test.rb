require 'test_helper'
require 'github_reporter'
require 'rspec'

class GithubReporterTest < Minitest::Test

	def setup
		@github_reporter = nil
		Configuration.stub(:new, Configuration.new('./configtest.yml')) do 
			@github_reporter = GithubReporter.new(Storage, Printer)
		end
		@printer = @github_reporter.instance_variable_get("@printer")
	end

	def test_log_level
		assert_equal 1, @github_reporter.config.log_level 
	end

	def test_config
		Configuration.stub(:new, Configuration.new('./configtest.yml')) do 
			assert_kind_of Configuration, @github_reporter.config
		end
	end
	
  	def test_start_and_print_report
    	STDOUT.stub(:puts, nil) do
    		data = File.read('testData.json')
			RestClient.stub(:get, data) do
    			@github_reporter.start
    			assert_includes ["ares", "iNecas", "tstrachota"], @github_reporter.instance_variable_get("@storage").users.first
    		end
    	end

    	out, err = capture_io do
			@github_reporter.print_report
		end
		assert out.include? @github_reporter.instance_variable_get("@storage").users.first
  	end

end
