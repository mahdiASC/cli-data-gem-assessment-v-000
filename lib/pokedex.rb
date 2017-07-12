class PokedexPokemon
  attr_accessor :name, :num, :type1, :type2, :hp, :att, :def, :spAtt, :spDef, :spd, :totalStats

  def initialize(obj)
    for
  end

  def clone
    # creates a copy of this pokedexPokemon object as a pokemon object
    return Pokemon.new(@name, @type1, @type2, @hp, @att, @def, @spAtt, @spDef, @spd)
  end
end
