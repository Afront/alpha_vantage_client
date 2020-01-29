# coding: utf-8
# frozen_string_literal: true
# rubocop:disable all
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/alpha_vantage_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'alpha_vantage_client'
  spec.version       = AlphaVantageClient::VERSION
  spec.authors       = ['Afront']
  spec.email         = ['3943720+Afront@users.noreply.github.com']

  spec.summary       = %q{An alpha_vantage client.}
  spec.description   = %q{An alpha_vantage client that uses the Alpha Vantage API}
  spec.homepage      = 'https://coding-everyday.works/gems/alpha_vantage_client'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/Afront/alpha_vantage_client/issues',
    'changelog_uri'     => 'https://github.com/Afront/alpha_vantage_client/CHANGELOG.md',
#   'documentation_uri' => 'https://coding-everyday.works/gems/alpha_vantage_client/0.0.1',
    'homepage_uri'      => spec.homepage,
#   'mailing_list_uri'  => 'https://coding-everyday.works/alpha_vantage_client',
    'source_code_uri'   => 'https://github.com/Afront/alpha_vantage_client',
    'wiki_uri'          => 'https://github.com/Afront/alpha_vantage_client/wiki'
  }

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split('\x0').reject { |f| f.match(%r{^(test|spec|features)/})}# ; puts f }
  end

# spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) } + ['alpha_vantage_client']
# spec.executables   = ['alpha_vantage_client']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake'
#  spec.add_development_dependency 'pry'
end
# rubocop:enable all
