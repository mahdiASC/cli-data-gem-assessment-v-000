class PoorPokemon::Move
  attr_accessor :name, :dmg, :type, :pp

  def initialize (name, dmg, type, pp)
    @name = "#{name} (#{type})"
    @dmg = dmg
    @type = type
    @pp = pp
  end

  def usable?
    #returns true if move has enough PP to be used
    @pp>0
  end
end
