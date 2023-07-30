# Faraday Retry Failover

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/invoca/faraday-retry-failover/ci)](https://github.com/invoca/faraday-retry-failover/actions?query=branch%3Amain)

An extension for the Faraday::Retry middleware allowing retries to failover across multiple resolved endpoints.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-retry-failover'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install faraday-retry-failover
```

## Usage

```ruby
require 'faraday/retry/failover'

# TODO
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, run `bin/test` to run the tests.

To install this gem onto your local machine, run `rake build`.

To release a new version, make a commit with a message such as "Bumped to 0.0.2" and then run `rake release`.
See how it works [here](https://bundler.io/guides/creating_gem.html#releasing-the-gem).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/invoca/faraday-retry-failover).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
