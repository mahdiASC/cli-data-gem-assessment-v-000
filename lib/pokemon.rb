class Pokemon
  attr_accessor :name, :type1, :type2, :hp, :att, :def, :spAtt, :spDef, :spd

  def initialize(arr)
    @name, @type1, @type2, @hp, @att, @def, @spAtt, @spDef, @spd = arr
  end


end
