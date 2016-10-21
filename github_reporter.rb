#!/usr/bin/env ruby

require 'logger'
require './configuration.rb'
require './github.rb'
require './storage.rb'
require './printer.rb'

class GithubReporter
  LOGGER = Logger.new(STDOUT)

  def initialize(storage_class, printer_class)
    LOGGER.level = config.log_level
    @storage = storage_class.new 
    @printer = printer_class.new @storage, config
  end

  def start
    config.repositories.each do |repo|
      data = Github.get_data(repo, config.users)
      @storage.update(data)
    end
    print_report
  end

  def print_report
    @printer.print
  end

  def config
    @config ||= Configuration.new('./config.yaml')
  end
end

if $0 =~ /github_reporter\.rb/
  begin
    GithubReporter.new(Storage, Printer).start
  rescue => e
    GithubReporter::LOGGER.error e.message
  end
end
