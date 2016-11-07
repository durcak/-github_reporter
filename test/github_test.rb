require "test_helper"
require 'github'



class GithubTest < Minitest::Test
	def setup
		@users = ["ares","inecas"]
		@repo = "theforeman/foreman"
		@github = Github.new(@repo, @users)
	end

	def test_url
		assert_equal 'https://api.github.com', Github.url
	end

	def test_list_url
		assert_equal "https://api.github.com/repos/theforeman/foreman/pulls?per_page=100", @github.send(:list_url)
	end

	def test_initialize
		assert_equal ["Ares","Inecas"].map(&:downcase), @github.instance_variable_get("@users")
		assert_equal "theforeman/foreman" , @github.instance_variable_get("@repo")
	end

	def test_get_data
		data = File.read('testData.json')
		
		RestClient.stub(:get, data) do
			output = @github.get_data
			assert_kind_of Hash, output
			assert output.keys.include? "ares"
			assert output.keys.include? "iNecas"
			assert_equal 2, output.keys.size
			assert_equal 3, output["ares"].size
			assert_equal 3984,  output["ares"].first[:number] 
		end
	end

	def test_get_attributes
		file = File.read('testData.json')
		prs = JSON.parse(file)
		prs = prs.select { |pr| @users.include?(pr['user']['login'].downcase) }
		result = @github.get_interesting_attributes(prs)

		assert_kind_of Hash, result
		assert_equal ["ares","inecas"], result.keys.map(&:downcase)
		assert_equal 2, result.keys.size
		assert_equal 3, result["ares"].size
		assert_equal 3984,  result["ares"].first[:number] 
  	end
end


