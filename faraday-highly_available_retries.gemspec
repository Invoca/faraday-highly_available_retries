# frozen_string_literal: true

require_relative 'lib/faraday/highly_available_retries/version'

Gem::Specification.new do |spec|
  spec.name    = 'faraday-highly_available_retries'
  spec.version = Faraday::HighlyAvailableRetries::VERSION
  spec.authors = ['Invoca Development', 'James Ebentier']
  spec.email   = ['development@invoca.com', 'jebentier@invoca.com']

  github_uri = "https://github.com/invoca/#{spec.name}"

  spec.summary = <<~SUMMARY.chomp
    An extension for the Faraday::Retry middleware allowing retries to failover across multiple resolved endpoints.
  SUMMARY

  spec.description = spec.summary
  spec.license     = 'MIT'
  spec.homepage    = github_uri
  spec.metadata    = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri' => "#{github_uri}/issues",
    'changelog_uri' => "#{github_uri}/blob/v#{spec.version}/CHANGELOG.md",
    'documentation_uri' => "http://www.rubydoc.info/gems/#{spec.name}/#{spec.version}",
    'homepage_uri' => spec.homepage,
    'source_code_uri' => github_uri,
    'wiki_uri' => "#{github_uri}/wiki"
  }

  spec.files = Dir['lib/**/*', 'README.md', 'LICENSE.md', 'CHANGELOG.md']

  spec.required_ruby_version = '>= 2.7', '< 4'

  spec.add_dependency 'faraday', '~> 2.0'
end
