require './basePlayer.rb'
class Enemy < BasePlayer
    def initialize(pokeGroup)
        @roster = pokeGroup
        @currentPokemon = @roster[0]
    end

    def switch
        #switches current pokemon (should be dead) for another valid pokemon
        @currentPokemon = @roster.select{|pokemon|pokemon.alive?}.sample
    end
end
