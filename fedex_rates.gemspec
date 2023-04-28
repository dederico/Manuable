Gem::Specification.new do |spec|
    spec.name          = "fedex_rates"
    spec.version       = "0.1.0"
    spec.authors       = ["Federico Gonzalez"]
    spec.email         = ["dederico@gmail.com"]
    spec.summary       = "A brief description of our gem, this gem by the moment is only printing the xml, werer missing the parsing to print the rates."
    spec.homepage      = "https://github.com/yourusername/yourgemname"
    spec.license       = "MIT"
  
    spec.files         = ["lib", "fedex_rates.rb"]
    spec.require_paths = ["lib"]
    spec.add_runtime_dependency "fedex_rates", "~> 0.1.0"
  end
  