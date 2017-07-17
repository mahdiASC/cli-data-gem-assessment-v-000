require './pokemon.rb'
class PokedexPokemon
  attr_accessor :name, :num, :type1, :type2, :hp, :att, :def, :spAtt, :spDef, :spd, :totalStats

  def initialize(arr)
    @name, @num, @type1,  @type2, @hp, @att, @def, @spAtt, @spDef, @spd, @totalStats = arr
  end

  def clone
    # creates a copy of this pokedexPokemon object as a pokemon object
    # moves is an array of moves
    return Pokemon.new([@name, @type1, @type2, @hp.to_i, @att.to_i, @def.to_i, @spAtt.to_i, @spDef.to_i, @spd.to_i])
  end
end