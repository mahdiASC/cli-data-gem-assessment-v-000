require('nokogiri')
require('open-uri')

class Pokedex
  def initialize

  # Pokemon database
  # http://pokedream.com/pokedex/pokemon?display=gen1
    pokemonDoc = Nokogiri::HTML(open("http://pokedream.com/pokedex/pokemon?display=gen1"))
    
  end
  
end

