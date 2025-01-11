# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keyless/version'

Gem::Specification.new do |spec|
  spec.name = 'keyless'
  spec.version = Keyless::VERSION
  spec.authors = ['Hermann Mayer', 'Christopher Mühl', 'Marcus Geißler']
  spec.email = ['hermann.mayer92@gmail.com',
                'christopher@padarom.xyz',
                'marcus3006@gmail.com']

  spec.license = 'MIT'
  spec.summary = 'A reusable JWT authentication helper'
  spec.description = 'A reusable JWT authentication helper'

  base_uri = "https://github.com/hausgold/#{spec.name}"
  spec.metadata = {
    'homepage_uri' => base_uri,
    'source_code_uri' => base_uri,
    'changelog_uri' => "#{base_uri}/blob/master/CHANGELOG.md",
    'bug_tracker_uri' => "#{base_uri}/issues",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{spec.name}"
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'activesupport', '>= 6.1'
  spec.add_dependency 'httparty', '>= 0.21'
  spec.add_dependency 'jwt', '~> 2.6'
  spec.add_dependency 'recursive-open-struct', '~> 2.0'
  spec.add_dependency 'zeitwerk', '~> 2.6'
end
