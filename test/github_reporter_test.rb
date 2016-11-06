require 'test_helper'
require 'github_reporter'
require 'rspec'

class GithubReporterTest < Minitest::Test

	def setup
		# @users = ["ares","inecas"]
		# @repo = "theforeman/foreman"
		# @github = Github.new(@repo, @users)
		@github_reporter = GithubReporter.new(Storage, Printer)
		#puts @github_reporter.config.log_level
	end

	def test_config
		assert_kind_of Configuration, @github_reporter.config
	end
	
  	# def test_start
  	# 	config = Configuration.new('./config.yaml.example')
   #  	@github_reporter.stub(:config, config) do
   #  		@github_reporter.start
   #  	end
  	# end

end
