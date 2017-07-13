require 'nokogiri'
require 'open-uri'
require './pokedexPokemon.rb'

class Pokedex
  attr_accessor :pokeList
  def initialize
  # Pokemon database
  # http://pokedream.com/pokedex/pokemon?display=gen1
    pokemonDoc = Nokogiri::HTML(open("http://pokedream.com/pokedex/pokemon?display=gen1"))
    @pokeList = pokemonDoc.css(".UILinkedTableRow").map{ |row|
      rowData = row.children().map{ |col|
        if col.attribute("class")
          col.attribute("class").value
        else
          col.text()
        end
      }.reject{|val| val == "\n" || val == "---"}
      rowData
    }.map{|row|
      PokedexPokemon.new(row)
    }
  end
end

