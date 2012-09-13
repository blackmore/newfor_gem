# -*- encoding: utf-8 -*-
require File.expand_path('../lib/newfor_gem/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nigel Blackmore"]
  gem.email         = ["nigel@blackmore.de"]
  gem.description   = %q{Very basic parser for NEWFOR Subtitle streams from wincaps}
  gem.summary       = %q{Very basic parser for NEWFOR Subtitle streams from wincaps}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "newfor_gem"
  gem.require_paths = ["lib"]
  gem.version       = NewforGem::VERSION

  gem.add_dependency "bindata"

  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "json_pure"

end
