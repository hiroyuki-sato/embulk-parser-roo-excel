Gem::Specification.new do |spec|
  spec.name          = "embulk-parser-roo-excel"
  spec.version       = "0.0.1"
  spec.authors       = ["Hiroyuki Sato"]
  spec.summary       = "Roo Excel parser plugin for Embulk"
  spec.description   = "Parses Excel files(xlsx) read by other file input plugins."
  spec.email         = ["hiroysato@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.homepage      = "https://github.com/hiroyuki-sato/embulk-parser-roo-excel"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'embulk', ['~> 0.7.5']
  spec.add_development_dependency 'bundler', ['~> 1.0']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_dependency 'roo', ['~> 2.0.1']
end