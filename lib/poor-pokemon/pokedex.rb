class PoorPokemon::Pokedex
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

  def bestSix(flag=false)
    #flag is for enemy to have perfect stats
    @pokeList.sort{|pokemonA,pokemonB| pokemonB.totalStats <=> pokemonA.totalStats}.take(6).map{|pokemon|pokemon.clone(flag)}
  end

  def randSix(flag=false)
    #flag is for enemy to have perfect stats
    randArray = []
    6.times do
      randArray.push(@pokeList.sample.clone(flag))
    end
    randArray
  end

  def searchName(word)
    @pokeList.select{|pokemon| pokemon.name[word]} 
  end

end

