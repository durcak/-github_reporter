# Github reporter

This small app parses a simple config file and accoring to this
configuration, it loads information from github regarding open
pull requests and print outs summary. Multiple github projects
and users can be specified. The summary aggregates all open PRs
of all repos on user basis.

## Installation

To install the application dependencies, use bundler.

## Usage

Create a configuration in a new file config.yaml, you can take a look
at config.yaml.example for inspiration (it's a working config file).
Then run

```
bundle exec ruby github_reporter.rb
```

it should print tables with open pull requests on configured github
repositories for specified users. Make sure your working directory
is the root of this app.

## Tests

To run test just use rake test task like this

```
bundle exec rake test
```
