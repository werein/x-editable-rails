# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'x-editable-rails/version'

Gem::Specification.new do |gem|
  gem.name          = "x-editable-rails"
  gem.version       = X::Editable::Rails::VERSION
  gem.authors       = ["Jiri Kolarik"]
  gem.email         = ["jiri.kolarik@imin.cz"]
  gem.description   = %q{X-editable for Rails}
  gem.summary       = %q{X-editable for Rails}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
