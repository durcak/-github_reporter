class Storage
  attr_reader :storage

  def initialize
    @storage = Hash.new { |h,k| h[k] = [] }
  end

  def update(data)
    data.keys.each do |user|
      @storage[user] = @storage[user] + data[user]
    end
  end

  def [](key)
    @storage[key]
  end

  def users
    @storage.keys.sort
  end

  def sorted_prs_for(user)
    @storage[user].sort_by { |pr| pr[:number] }
  end
end
