require './basePlayer.rb'
class Enemy < BasePlayer
    attr_accessor :roster, :currentPokemon

    def initialize(pokeGroup)
        @roster = pokeGroup
        @currentPokemon = @roster[0]
    end
end
