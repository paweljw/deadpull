# frozen_string_literal: true

lib = File.expand_path('./lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deadpull/version'

Gem::Specification.new do |spec|
  spec.name          = 'deadpull'
  spec.version       = Deadpull::VERSION
  spec.authors       = ['Paweł J. Wal']
  spec.email         = ['pawel.wal@codesthq.com']

  spec.summary       = 'Share config securely with your servers and organization using AWS S3.'
  spec.homepage      = 'https://github.com/paweljw/deadpull'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
