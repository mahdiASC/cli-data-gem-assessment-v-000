require 'nokogiri'
require 'open-uri'
require './pokedexPokemon.rb'

class Pokedex
  attr_accessor :pokeList
  def initialize
  # Pokemon database
  # http://pokedream.com/pokedex/pokemon?display=gen1
    pokemonDoc = Nokogiri::HTML(open("http://pokedream.com/pokedex/pokemon?display=gen1"))
    # pokemonDoc = Nokogiri::HTML(open("C:/Users/Jordan Brodie/Desktop/Pokedex __ PokeDream.html"))
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

  def bestSix
    @pokeList.sort{|pokemonA,pokemonB| pokemonB.totalStats <=> pokemonA.totalStats}.take(6).map{|pokemon|pokemon.clone}
  end

  def randSix
    randArray = []
    6.times do
      randArray.push(@pokeList.sample.clone)
    end
    randArray
  end

  def searchName(word)
    @pokeList.select{|pokemon| pokemon.name[word]} 
  end

end

