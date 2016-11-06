require 'test_helper'

require 'storage'
require 'configuration'
require 'printer'

class PrinterTest < Minitest::Test
	def setup
		@storage = Storage.new()
		@storage["Peter"] << {:number=>225, :title=>"Fixes #17021 - properly detect booleans", :url=>"https://github.com/theforeman/hammer-cli/pull/225"}
		@storage["Jan"] << {:number=>243, :title=>"Fixes #3", :url=>"https://github.com/..."}
		@configuration = Configuration.new('configtest.yml')
		@printer = Printer.new(@storage, @configuration)
	end

	def test_initialize
		assert_equal @storage, @printer.instance_variable_get("@storage")
		assert_equal @configuration.line_size, @printer.instance_variable_get("@line_size")
		assert_equal 5, @printer.instance_variable_get("@max_pr_digits")
	end

	def test_line_divider
		assert_equal "=" * @configuration.line_size, @printer.line_divider
	end

	def test_format_number
		assert_equal "#999 ", @printer.format_number(999)

		@printer.instance_variable_set(:@max_pr_digits, 1000)
		assert_equal "#999".ljust(1000), @printer.format_number(999)
	end

	def test_format_link
		url = "https://api.github.com/repos/theforeman/foreman/pulls?per_page=100"
		@printer.stub(:max_pr_url_size, 100) { assert_equal url.ljust(100), @printer.format_link(url) }
	end

	def test_format_title
		@printer.stub(:max_pr_url_size, 65) do
			title = "https://api.github.com/repos/theforeman/foreman/pulls?per_page=100"
			max = 40
  			assert_equal title[0..max-1], @printer.format_title(title)

  			title = "https://api.github.com/"
  			assert_equal title.ljust(max), @printer.format_title(title)
		end
	end

	def test_max_pr_url_size  	
		excepted_max_url_size = "https://github.com/theforeman/hammer-cli/pull/225".size
		assert_equal excepted_max_url_size, @printer.max_pr_url_size
	end

	def test_print
		out, err = capture_io do
			@printer.print
		end
			assert out.include?('Jan')
			assert out.include?('Peter')

		@storage.users.each do |author|
			assert out.include? author
			assert out.include? @printer.line_divider
			@storage.sorted_prs_for(author).each do |pr|
				assert out.include? pr[:number].to_s
				assert out.include? @printer.format_link(pr[:url])
				assert out.include? @printer.format_title(pr[:title])
			end
		end
	end
end