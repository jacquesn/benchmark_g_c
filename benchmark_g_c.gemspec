# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'benchmark_g_c/version'

Gem::Specification.new do |spec|
  spec.name          = "benchmark_g_c"
  spec.version       = BenchmarkGC::VERSION
  spec.authors       = ["Nicholas Jacques"]
  spec.email         = ["jnicholasjacques@gmail.com"]

  spec.summary       = %q{Benchmark Garbage Collect stats relevant to memory optimization.}
  spec.homepage      = "https://github.com/jacquesn/benchmark_g_c"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
