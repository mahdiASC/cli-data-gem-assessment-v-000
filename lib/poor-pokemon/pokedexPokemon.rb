class PoorPokemon::PokedexPokemon
  attr_accessor :name, :num, :type1, :type2, :hp, :att, :def, :spAtt, :spDef, :spd, :totalStats

  def initialize(arr)
    @name, @num, @type1,  @type2, @hp, @att, @def, @spAtt, @spDef, @spd, @totalStats = arr
  end

  def clone (flag=false)
    # creates a copy of this pokedexPokemon object as a pokemon object
    # moves is an array of moves
    #flag is for enemy to have perfect stats
    return Pokemon.new([@name, @type1, @type2, @hp.to_i, @att.to_i, @def.to_i, @spAtt.to_i, @spDef.to_i, @spd.to_i], flag)
  end
end