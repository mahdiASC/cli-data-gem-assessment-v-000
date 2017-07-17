class BasePlayer
    attr_accessor :roster, :currentPokemon

     def allDead?
        # returns true if no more pokemon left to play
        !@roster.any?{|pokemon| pokemon.alive?}
    end
    
    def changeCurrent(number)
        #changes currentPokemon to the pokemon in roster under "number" index
        @currentPokemon = @roster[number]
    end

end