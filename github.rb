require 'json'
require 'restclient'

class Github
  def self.get_data(repo, users)
    new(repo, users).get_data
  end

  def self.url
    'https://api.github.com'
  end

  def initialize(repo, users)
    @repo = repo
    @users = users.map(&:downcase)
  end

  def get_data
    prs = JSON.parse(fetch_response)
    GithubReporter::LOGGER.debug "parsed #{prs.size} PRs"
    prs = prs.select { |pr| @users.include?(pr['user']['login'].downcase) }
    get_interesting_attributes(prs)
  end

  def get_interesting_attributes(prs)
    result = Hash.new { |h,k| h[k] = [] }
    prs.each do |pr| 
      result[pr['user']['login']] << { :number => pr['number'], :title => pr['title'], :url => pr['html_url'] }
    end
    result
  end

  private

  def fetch_response
    GithubReporter::LOGGER.debug "fetching from #{list_url}"
    RestClient.get(list_url)
  end

  def list_url
    "#{self.class.url}/repos/#{@repo}/pulls?per_page=100"
  end
end
