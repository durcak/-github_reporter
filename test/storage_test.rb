require 'test_helper'
require 'storage'

class StorageTest < Minitest::Test
	def setup
		@storage = Storage.new()
		@storage["Peter"] << {:number=>1}
		@storage["Jan"] << {:number => 2}
	end

	def test_Initialize
		str = Storage.new()
		assert_equal str.storage, {}
	end

	def test_Users
		assert_equal  ["Jan", "Peter"], @storage.users
	end

	def test_Key
		assert_equal  [{:number => 2 }], @storage["Jan"]
	end

	def test_Update
		data = {"Jan"  => [{ :number => 6}]}
		@storage.update(data)
		assert_equal [{:number => 2 },{ :number => 6 }], @storage["Jan"]
	end

	def test_Sorted_prs_for
		data = {"Jan"  => [{ :number => 6 },{ :number => 145 }]}
		@storage.update(data)
		assert_equal  [{:number => 2 },{ :number => 6 },{ :number => 145 }], @storage.sorted_prs_for("Jan")
	end

end

