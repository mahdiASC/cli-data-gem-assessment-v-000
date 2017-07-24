# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "poor-pokemon/version"

Gem::Specification.new do |spec|
  spec.authors       = ["Mahdi Shadkam-Farrokhi"]
  spec.email         = ["mahdi@allstarcode.org"]
  spec.description   = "A simple pokemon CLI"
  spec.summary       = "In this simple CLI gem game, the player selects whatever pokemon they want from their pokedex to be added to their roster of 6, and then battles against an opponent, \"Poorly Designed Boss\"."
  spec.version       = PoorPokemon::VERSION
  spec.homepage      = 'https://github.com/mahdiASC/cli-data-gem-assessment-v-000'
  spec.date          = Time.now.utc.strftime("%Y-%m-%d")
  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["poor-pokemon"]
  spec.name          = "poor-pokemon-cli"
  spec.require_paths = ["lib", "lib/poor-pokemon"]
  spec.license       = "MIT"

  spec.add_development_dependency "pry"
  
  spec.add_dependency "nokogiri"
end