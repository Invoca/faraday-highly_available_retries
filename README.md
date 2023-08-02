# Faraday Highly Available Retries

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/invoca/faraday-highly_available_retries/ci)](https://github.com/invoca/faraday-highly_available_retries/actions?query=branch%3Amain)

An extension for the Faraday::Retry middleware allowing retries to failover across multiple resolved endpoints.

## Why should I use this gem?

At the time a request is made, the list of hosts pulled from the connection and request is resolved to an array of IP addresses.
This list of IP addresses is then shuffled, and if a request fails to connect to the first IP address, it will try the next one.
And so on and so forth, until the retries are exhausted. If all of the IPs fail, then we cycle back to the first one and try again.

The reason this is impactful and should be used in conjunction with the retry middleware is that the retry middleware will
leave DNS resolution to the OS, which has the potential of caching results and not try resolving to a different IP address.
This means that if a DNS entry resolves to three IPs, `[A, B, C]`, the retry middleware may try all three retries against
`A`, where as this middleware guarantees that it will try `A`, `B`, and `C`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-highly_available_retries'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install faraday-highly_available_retries
```

## Usage

This extension can be used on its own but is ultimately meant to be used in tandem with the [Faraday::Retry](https://github.com/lostisland/faraday-retry) middleware.
You should make sure that this middleware is added in the request stack ***after*** the retry middleware to ensure
it can alter the environment on retries.

When you configure the connection, you can do it a few different ways for the failover to work.

### Setting the URL in the request

This simplest way is to make a generic Faraday connection, and pass the full URI in the request.
When this is done, the failover middleware will parse the URI and use the host and port to determine
the failover endpoints using DNS resolution.

```ruby
require 'faraday/retry/failover'

conn = Faraday.new do |f|
  f.request :retry, { max: 2 } # This makes sure we retry 2, resulting in 3 attempts total before failing finally
  f.request :highly_available_retries
end

conn.get('https://api.invoca.net/api/2020-10-01/transaction/33.json')
```

### Setting the base URL in the connection

This is the same as the previous example, but the base URL is set in the connection. This is useful
when the base URL is always the same, and you have a DNS entry that will resolve to multiple IPs.

```ruby
require 'faraday/retry/failover'

conn = Faraday.new('https://api.invoca.net') do |f|
  f.request :retry, { max: 2 }
  f.request :highly_available_retries
end

conn.get('/api/2020-10-01/transaction/33.json')
```

### Specifying multiple hosts

This is the most useful when you already have multiple IPs or separate hostnames that you want to
use for failover. The hosts list provided can contain hostnames and IPs both with and without ports.

```ruby
conn = Faraday.new do |f|
  f.request :retry, { max: 2 }
  f.request :highly_available_retries, { hosts: ['api.invoca.net', 'api.invoca.com'] }
end

conn.get('/api/2020-10-01/transaction/33.json')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Then, run `bin/test` to run the tests.

To install this gem onto your local machine, run `rake build`.

To release a new version, make a commit with a message such as "Bumped to 0.0.2" and then run `rake release`.
See how it works [here](https://bundler.io/guides/creating_gem.html#releasing-the-gem).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/invoca/faraday-highly_available_retries).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
