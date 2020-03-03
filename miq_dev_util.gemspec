# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miq_dev_util/version'

Gem::Specification.new do |spec|
  spec.name          = "miq_dev_util"
  spec.version       = MiqDevUtil::VERSION
  spec.authors       = ["Eric Wannemacher"]
  spec.email         = ["eric@wannemacher.us"]

  spec.summary       = %q{A set of helper classes to make ManageIQ automate
    development easier and to try and eliminate copy and paste of commonly
    used code.}
  spec.homepage      = "https://github.com/ewannema/miq_dev_util"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec"
end
