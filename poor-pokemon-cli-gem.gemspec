Gem::Specification.new do |spec|
  spec.authors       = ["Mahdi Shadkam-Farrokhi"]
  spec.email         = ["mahdi@allstarcode.org"]
  spec.description   = "A simple pokemon CLI"
  spec.summary       = "In this simple CLI gem game, the player selects whatever pokemon they want from their pokedex to be added to their roster of 6, and then battles against an opponent, \"Poorly Designed Boss\"."
  spec.version       = "1.0.0"

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["poor-pokemon"]
  spec.name          = "poor-pokemon-cli"
  spec.require_paths = ["lib", "lib/poor-pokemon"]
  spec.license       = "MIT"

  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry"
end