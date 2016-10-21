class Printer
  

  def initialize(storage, configuration)
    @storage = storage
    @line_size = (configuration.line_size).to_i
    @max_pr_digits = (configuration.max_pr_digits).to_i + 1
  end

  def print
    @storage.users.each do |author|
      puts author
      puts line_divider
      @storage.sorted_prs_for(author).each do |pr|
        puts '| ' + format_number(pr[:number]) + ' | ' + format_link(pr[:url]) + ' | ' + format_title(pr[:title]) + ' |'
      end
      puts
    end
  end

  def line_divider
    "=" * @line_size
  end

  def format_number(n)
    "##{n}".ljust(@max_pr_digits)
  end

  def format_link(url)
    url.ljust(max_pr_url_size)
  end

  def format_title(title)
    max = @line_size - @max_pr_digits - max_pr_url_size - 10
    title.size > max ? title[0..max-1] : title.ljust(max)
  end

  def max_pr_url_size
    @max_pr_url_size ||= @storage.storage.values.flatten.sort_by { |pr| pr[:url].size }.last[:url].size
  end
end
